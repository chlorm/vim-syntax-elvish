" Copyright (c) 2018-2020, Cody Opel <cwopel@chlorm.net>
"
" Licensed under the Apache License, Version 2.0 (the "License");
" you may not use this file except in compliance with the License.
" You may obtain a copy of the License at
"
"     http://www.apache.org/licenses/LICENSE-2.0
"
" Unless required by applicable law or agreed to in writing, software
" distributed under the License is distributed on an "AS IS" BASIS,
" WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
" See the License for the specific language governing permissions and
" limitations under the License.

if exists("b:current_syntax")
  finish
endif

let b:current_syntax = 'elvish'

" Elvish allows hyphens in variable and function names
set iskeyword+=-

" Slower, but prevents some elements from not being highlighted when scrolling.
syntax sync fromstart

let b:bareChar = '%([a-zA-Z0-9_-])'
let b:bareWord = '%(' . b:bareChar . '+)'
let b:negateBehind = '%(' . b:bareChar . '|[&.=*<>:])@<!'
let b:negateAhead =  b:bareChar . '@!'
" FIXME: should only be whitespace chars
let b:cmdAhead = '%(\s|\n)@='

"
"" Builtin Commands
"

let b:builtinCommands = [
  \ 'all',
  \ 'assoc',
  \ 'base',
  \ 'bool',
  \ 'cd',
  \ 'constantly',
  \ 'count',
  \ 'dir-history',
  \ 'dissoc',
  \ 'drop',
  \ 'each',
  \ 'eawk',
  \ 'echo',
  \ 'esleep',
  \ 'eval-symlinks',
  \ 'exec',
  \ 'exit',
  \ 'external',
  \ 'fail',
  \ 'fclose',
  \ 'fg',
  \ 'float64',
  \ 'fopen',
  \ 'from-json',
  \ 'from-lines',
  \ 'get-env',
  \ 'has-env',
  \ 'has-external',
  \ 'has-key',
  \ 'has-prefix',
  \ 'has-suffix',
  \ 'has-value',
  \ 'keys',
  \ 'kind-of',
  \ 'make-map',
  \ 'multi-error',
  \ 'nop',
  \ 'ns',
  \ 'one',
  \ 'only-bytes',
  \ 'only-values',
  \ 'order',
  \ 'path-abs',
  \ 'path-base',
  \ 'path-clean',
  \ 'path-dir',
  \ 'path-ext',
  \ 'peach',
  \ 'pipe',
  \ 'pprint',
  \ 'prclose',
  \ 'print',
  \ 'pprint',
  \ 'put',
  \ 'pwclose',
  \ 'range',
  \ 'rand',
  \ 'randint',
  \ 'read-line',
  \ 'read-upto',
  \ 'repeat',
  \ 'repr',
  \ 'resolve',
  \ 'run-parallel',
  \ 'search-external',
  \ 'set-env',
  \ 'show',
  \ 'styled',
  \ 'styled-segment',
  \ 'slurp',
  \ 'spawn',
  \ 'src',
  \ 'take',
  \ 'tilde-abbr',
  \ 'time',
  \ 'to-json',
  \ 'to-lines',
  \ 'to-string',
  \ 'unset-env',
  \ 'wcswidth',
  \ '-gc',
  \ '-ifaddrs',
  \ '-is-dir',
  \ '-log',
  \ '-override-wcwidth',
  \ '-source',
  \ '-stack',
  \ ]
syntax match elvishBuiltinCommand
  \ '"'
execute 'syntax match elvishBuiltinCommand'
  \ '"\v' . b:negateBehind . 
    \ '(' . join(b:builtinCommands, '|') . ')' . 
  \ b:cmdAhead . '"'
highlight default link elvishBuiltinCommand Builtin

"
"" Builtin Variables
"

syntax match elvishBuiltinVariable "$_"
syntax match elvishBuiltinVariable "$after-chdir"
syntax match elvishBuiltinVariable "$args"
syntax match elvishBuiltinVariable "$before-chdir"
syntax match elvishBuiltinVariable "$E"
syntax match elvishBuiltinVariable "$ok"
syntax match elvishBuiltinVariable "$nil"
syntax match elvishBuiltinVariable "$num-bg-jobs"
syntax match elvishBuiltinVariable "$notify-bg-job-access"
syntax match elvishBuiltinVariable "$paths"
syntax match elvishBuiltinVariable "$pid"
syntax match elvishBuiltinVariable "$pwd"
syntax match elvishBuiltinVariable "$value-out-indicator"
highlight default link elvishBuiltinVariable Builtin

"
"" Control Flow
"

syntax keyword elvishStatement break continue return
highlight default link elvishStatement Statement

" FIXME: else conflict, need region
syntax keyword elvishConditional if elif else
highlight default link elvishConditional Conditional
" FIXME: else conflict, need region
syntax keyword elvishRepeat for while else
highlight default link elvishRepeat Repeat
" FIXME: else conflict, need region
syntax keyword elvishException try except else finally
highlight default link elvishException Exception

syntax cluster elvishControlFlow
  \ contains=
    \ elvishConditional,
    \ elvishException,
    \ elvishRepeat,
    \ elvishStatement

"
"" Modules
"

syntax keyword elvishInclude use
highlight default link elvishInclude Include

"
"" Booleans
"

syntax match elvishBoolean "$true"
syntax match elvishBoolean "$false"
highlight default link elvishBoolean Boolean

"
""  Numbers
"

" TODO: negatives, floats, scientific notation, octal

" FIXME: backup port fixes from textmate grammar
syntax match elvishNumberDecimal '\v([&$])@<!(\d+)'
highlight default link elvishNumberDecimal elvishNumber

" FIXME: backup port fixes from textmate grammar
syntax match elvishNumberHexidecimal '\v0[xX][0-9a-fA-F]+'
highlight default link elvishNumberHexidecimal elvishNumber

syntax cluster elvishNumber
  \ contains=
    \ elvishNumberDecimal,
    \ elvishNumberHexidecimal
highlight default link elvishNumber Number

"
"" Operators
"

execute 'syntax match elvishOperatorArithmetic'
  \ '"\v' . b:negateBehind . '([+/%*-])' . b:cmdAhead . '"'
highlight default link elvishOperatorArithmetic elvishOperator

syntax match elvishOperatorAssignment '\v([=])'
highlight default link elvishOperatorAssignment elvishOperator

let b:compOpts = [
  \ 'eq'
  \ 'not\-eq'
  \ 'is'
  \ '\<%[s]'
  \ '\<\=%[s]'
  \ '\>%[s]'
  \ '\>\=%[s]'
  \ '\!\=%[s]'
  \ '\=\=%[s]'
  \ ]
execute 'syntax match elvishOperatorComparison'
  \ '"\v' . b:negateBehind . '(' . join(b:compOpts, '|') . ')' . b:cmdAhead . '"'
highlight default link elvishOperatorComparison elvishOperator

execute 'syntax match elvishOperatorLogical'
  \ '"\v' . b:negateBehind . '(and|or|not)' . b:cmdAhead . '"'
highlight default link elvishOperatorLogical elvishOperator

syntax match elvishOperatorOther '\v([;|?,&*])'
highlight default link elvishOperatorOther elvishOperator

syntax cluster elvishOperator
  \ contains=
    \ elvishOperatorArithmetic,
    \ elvishOperatorAssignment,
    \ elvishOperatorComparison,
    \ elvishOperatorLogical,
    \ elvishOperatorOther
highlight default link elvishOperator Operator

"
"" Comments
"

" FIXME: would be nice to not implement this per-language
syntax keyword elvishTodo contained
  \ BUG
  \ CHANGED
  \ DEBUG
  \ FIXME
  \ HACK
  \ IDEA
  \ NOTE
  \ OPTIMIZE
  \ QUESTION
  \ REVIEW
  \ TODO
  \ WARNING
  \ XXX
  \ ???
highlight default link elvishTodo Todo

syntax match elvishComment "#.*$" 
  \ contains=
    \ elvishTodo
highlight default link elvishComment Comment

"
"" Functions
"

" FIXME: works with only including statement, but cluster fails to work
syntax keyword elvishFunctionStatement fn nextgroup=elvishFunctionName skipwhite
highlight default link elvishFunctionStatement Statement
execute 'syntax match elvishFunctionName contained'
  \ '"\v' . b:negateBehind . '%(fn\s+)@<=(' . b:bareWord . ')' . '"'
highlight default link elvishFunctionName Function
syntax cluster elvishFunction
  \ contains=
    \ elvishFunctionName,
    \ elvishFunctionStatement

"
"" Variables
"

" TODO: highlight rest arg symbol
execute 'syntax match elvishVariableAccess'
  \ '"' . b:negateBehind . '[$]\%[@]' . b:bareWord . '\%[\~]' . '"'
  \ 'contains='
    \ 'elvishBoolean,'
    \ 'elvishBuiltinVariable'
highlight default link elvishVariableAccess elvishVariable
highlight default link elvishVariable Normal
syntax cluster elvishVariable
  \ contains=
    \ elvishVariableAccess

"
"" Strings
"

" FIXME: implement missing escapes
syntax match elvishStringEscapeDouble '\(\\["n]\)' contained
highlight default link elvishStringEscapeDouble elvishStringConstant

syntax match elvishStringEscapeSingle "\(['][']\)" contained
highlight default link elvishStringEscapeSingle elvishStringConstant

syntax cluster elvishStringConstant
  \ contains=
    \ elvishStringEscapeDouble,
    \ elvishStringEscapeSingle
highlight default link elvishStringConstant Constant

syntax region elvishStringDouble matchgroup=elvishStringDelimiter start='["]' end='["]'
  \ contains=
    \ elvishStringEscapeDouble
highlight default link elvishStringDouble elvishString

syntax region elvishStringSingle matchgroup=elvishStringDelimiter start="[']"  end="[']\%([']\)\@!"
  \ contains=
    \ elvishStringEscapeSingle
highlight default link elvishStringSingle elvishString

syntax cluster elvishString
  \ contains=
    \ elvishStringDouble,
    \ elvishStringSingle
highlight default link elvishString String

highlight default link elvishStringDelimiter String

"
"" Command Substitution
"

syntax region elvishCommandSubstitution start="(" end=")"
  \ contains=
    \ elvishBoolean,
    \ elvishBuiltinCommand,
    \ elvishBuiltinVariable,
    \ elvishComment,
    \ elvishMap,
    \ @elvishNumber,
    \ @elvishOperator,
    \ @elvishString,
    \ @elvishVariable

"
"" Lambdas
"

syntax region elvishLambda start="{" end="}"
  \ contains=
    \ elvishBoolean,
    \ elvishBuiltinCommand,
    \ elvishBuiltinVariable,
    \ elvishComment,
    \ @elvishControlFlow,
    \ @elvishFunction,
    \ elvishInclude,
    \ elvishMap,
    \ @elvishNumber,
    \ @elvishOperator,
    \ @elvishString,
    \ @elvishVariable

"
"" Maps
"

syntax match elvishBareWord '\(\w\|[-]\)\+' contained
syntax region elvishMapKey matchgroup=Operator
  \ start="\(&\)\%(\w\|[$'\"-]\)\@="
  \ end="\%(\w\|['\"-]\)\@<=\(\%[=]\)"
  \ contains=
    \ elvishBareWord,
    \ @elvishString,
    \ @elvishVariable
highlight default link elvishMapKey FunctionArgument
syntax region elvishMap start="\[" end="]"
  \ contains=
    \ elvishBoolean,
    \ elvishBuiltinVariable,
    \ elvishCommandSubstitution,
    \ elvishMapKey,
    \ @elvishNumber,
    \ @elvishOperator,
    \ @elvishString,
    \ @elvishVariable

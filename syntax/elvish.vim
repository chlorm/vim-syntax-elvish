" Copyright (c) 2018-2021, Cody Opel <cwopel@chlorm.net>
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

let b:bareChar = '%([a-zA-Z0-9_!%+,/@\\:.-])'
let b:bareWord = '%(' . b:bareChar . '+)'
let b:negateBehind = '%(' . b:bareChar . '|[=])@<!'
let b:negateAhead =  b:bareChar . '@!'
" FIXME: should only be whitespace chars
let b:cmdAhead = '%(\s|\n)@='

"
"" Command Substitution
"

syntax region elvishCommandSubstitution start="(" end=")"
  \ contains=
    \ elvishBuiltinVariable,
    \ elvishComment,
    \ @elvishControlFlow,
    \ @elvishFunctions,
    \ elvishMap,
    \ @elvishNumber,
    \ @elvishRedirection,
    \ @elvishOperator,
    \ @elvishString,
    \ @elvishVariable

"
"" Comments
"

syntax match elvishComment "#.*$" 
  \ contains=
    \ elvishTodo
highlight default link elvishComment Comment

"
"" Control Flow
"

syntax keyword elvishStatement break continue return
highlight default link elvishStatement Statement
syntax keyword elvishConditional if elif else
highlight default link elvishConditional Conditional
syntax keyword elvishRepeat for while
highlight default link elvishRepeat Repeat
syntax keyword elvishException try catch finally
highlight default link elvishException Exception

syntax cluster elvishControlFlow
  \ contains=
    \ elvishConditional,
    \ elvishException,
    \ elvishRepeat,
    \ elvishStatement

"
"" Functions
"

let b:builtinCommands = [
  \ 'all',
  \ 'assoc',
  \ 'base',
  \ 'bool',
  \ 'call',
  \ 'cd',
  \ 'constantly',
  \ 'count',
  \ 'defer',
  \ 'deprecate',
  \ 'dir-history',
  \ 'dissoc',
  \ 'drop',
  \ 'each',
  \ 'eawk',
  \ 'echo',
  \ 'eval',
  \ 'exec',
  \ 'exit',
  \ 'external',
  \ 'fail',
  \ 'fg',
  \ 'float64',
  \ 'from-json',
  \ 'from-lines',
  \ 'get-env',
  \ 'has-env',
  \ 'has-external',
  \ 'has-key',
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
  \ 'peach',
  \ 'pprint',
  \ 'print',
  \ 'pprint',
  \ 'put',
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
  \ 'sleep',
  \ 'slurp',
  \ 'spawn',
  \ 'src',
  \ 'styled',
  \ 'styled-segment',
  \ 'take',
  \ 'tilde-abbr',
  \ 'time',
  \ 'tmp',
  \ 'to-json',
  \ 'to-lines',
  \ 'to-string',
  \ 'unset-env',
  \ 'wcswidth',
  \ '-gc',
  \ '-ifaddrs',
  \ '-log',
  \ '-override-wcwidth',
  \ '-stack',
  \ ]
execute 'syntax match elvishBuiltinCommand'
  \ '"\v' . b:negateBehind .
    \ '(' . join(b:builtinCommands, '|') . ')' .
  \ b:negateAhead . '"'
highlight default link elvishBuiltinCommand Builtin

syntax keyword elvishFunctionStatement fn nextgroup=elvishFunctionName skipwhite
highlight default link elvishFunctionStatement Statement
execute 'syntax match elvishFunctionName contained'
  \ '"\v' . b:negateBehind . '%(fn\s+)@<=(' . b:bareWord . ')"'
highlight default link elvishFunctionName Function
syntax cluster elvishFunctions
  \ contains=
    \ elvishBuiltinCommand,
    \ elvishFunctionName,
    \ elvishFunctionStatement

"
"" Lambdas
"

syntax region elvishLambda start="{" end="}"
  \ contains=
    \ elvishBuiltinVariable,
    \ elvishCommandSubstitution,
    \ elvishComment,
    \ @elvishControlFlow,
    \ @elvishFunctions,
    \ elvishInclude,
    \ elvishRedirection,
    \ @elvishMap,
    \ @elvishNumber,
    \ @elvishOperator,
    \ @elvishString,
    \ @elvishVariable

"
"" Maps
"

execute 'syntax match elvishBareWord' "\"\v(" . b:bareWord . ")+\"" 'contained'
execute 'syntax region elvishMapKey matchgroup=Operator'
  \ "start=\"\v(&)%(" . b:bareChar . "|[$'\"])@=\""
  \ "end=\"\v%(" . b:bareChar . "|['\"])@<=(%[=])\""
  \ 'contains='
    \ 'elvishBareWord,'
    \ '@elvishString,'
    \ '@elvishVariable'
highlight default link elvishMapKey FunctionArgument
" FIXME:
execute 'syntax match elvishListRange contained'
  \ "\"\v(..)%(" . '[a-zA-Z0-9_-]' . "|[\]])@=\""
highlight default link elvishListRange Statement
syntax region elvishMap start="\[" end="]"
  \ contains=
    \ elvishBuiltinVariable,
    \ elvishCommandSubstitution,
    \ elvishComment,
    \ elvishListRange,
    \ elvishMapKey,
    \ @elvishNumber,
    \ @elvishOperator,
    \ @elvishString,
    \ @elvishVariable

"
"" Modules
"

" TODO: port changes for use matching, namespace matching, & builtin namespaces.
syntax keyword elvishInclude use
highlight default link elvishInclude Include

"
""  Numbers
"

" TODO: scientific notation, octal

let b:behind = '%(%([.][.])@<=|' . b:bareChar . '@<!)'
let b:ahead = '%([.]%([.])@!|' . substitute(b:bareChar, '\.', '', '') . '|[>])@!'
let b:sign = '%(%[\+]|%[-])'

execute 'syntax match elvishNumberDecimal'
  \ '"\v' . b:behind . '(' . b:sign . '[0-9_]+)' . b:ahead . '"'
highlight default link elvishNumberDecimal elvishNumber

execute 'syntax match elvishNumberFloat'
  \ '"\v' . b:behind . '(' . b:sign . '%([0-9_]+|)\.[0-9_]+|[0-9_]+\.%([0-9_]+|))' . b:ahead . '"'
highlight default link elvishNumberFloat elvishNumber

execute 'syntax match elvishNumberHexidecimal'
  \ '"\v' . b:behind . '(' . b:sign . '\v0[xX][0-9a-fA-F]+)' . b:ahead . '"'
highlight default link elvishNumberHexidecimal elvishNumber

syntax cluster elvishNumber
  \ contains=
    \ elvishNumberDecimal,
    \ elvishNumberFloat,
    \ elvishNumberHexidecimal
highlight default link elvishNumber Number

"
"" Redirections
"

let b:redirections = [
  \ '\<',
  \ '\>\>',
  \ '[0-9]\>\&\-',
  \ '\>\&\-',
  \ '[0-9]\>\&[0-9]',
  \ '[0-9]\>',
  \ '\>\&[0-9]',
  \ ]
execute 'syntax match elvishRedirection'
  \ '"\v(' . join(b:redirections, '|') . ')"'
highlight default link elvishRedirection elvishOperator

"
"" Operators
"

execute 'syntax match elvishOperatorArithmetic'
  \ '"\v' . b:negateBehind . '([+/%*-])' . b:cmdAhead . '"'
highlight default link elvishOperatorArithmetic elvishOperator

syntax keyword elvishOperatorAssignment set var
syntax match elvishOperatorAssignment '\v([=])'
highlight default link elvishOperatorAssignment elvishOperator

let b:comparisonOperators = [
  \ 'eq',
  \ 'not\-eq',
  \ 'is',
  \ '\<%[s]',
  \ '\<\=%[s]',
  \ '\>%[s]',
  \ '\>\=%[s]',
  \ '\!\=%[s]',
  \ '\=\=%[s]',
  \ ]
execute 'syntax match elvishOperatorComparison'
  \ '"\v' . b:negateBehind .
    \ '(' . join(b:comparisonOperators, '|') . ')' .
  \ b:cmdAhead . '"'
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
"" Strings
"

" Single character escapes
syntax match elvishStringEscapeDouble '\v\\["\\abfnrtv]' contained
" Octal
syntax match elvishStringEscapeDouble '\v\\[0-7][0-7][0-7]' contained
" Unicode code point
syntax match elvishStringEscapeDouble '\v\\[c^].' contained
" Unicode code point 2 digit hex
syntax match elvishStringEscapeDouble '\v\\x[0-9a-fA-F]{2}' contained
" Unicode code point 4 digit hex
syntax match elvishStringEscapeDouble '\v\\u[0-9a-fA-F]{4}' contained
" Unicode code point 8 digit hex
syntax match elvishStringEscapeDouble '\v\\U[0-9a-fA-F]{8}' contained
highlight default link elvishStringEscapeDouble elvishStringConstant

syntax match elvishStringEscapeSingle "\v([']['])" contained
highlight default link elvishStringEscapeSingle elvishStringConstant

syntax cluster elvishStringConstant
  \ contains=
    \ elvishStringEscapeDouble,
    \ elvishStringEscapeSingle
highlight default link elvishStringConstant Constant

syntax region elvishStringDouble matchgroup=elvishStringDelimiter
  \ start='\v["]'
  \ end='\v["]'
  \ contains=
    \ elvishStringEscapeDouble
highlight default link elvishStringDouble elvishString

syntax region elvishStringSingle matchgroup=elvishStringDelimiter
  \ start="\v[']"
  \ end="\v[']%(['])@!"
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
"" Variables
"

let b:builtinVariables = [
  \ '_',
  \ 'after-chdir',
  \ 'args',
  \ 'before-chdir',
  \ 'ok',
  \ 'nil',
  \ 'num-bg-jobs',
  \ 'notify-bg-job-access',
  \ 'paths',
  \ 'pid',
  \ 'pwd',
  \ 'value-out-indicator',
  \ ]
execute 'syntax match elvishBuiltinVariable'
  \ '"' . '\v([$]%(' . join(b:builtinVariables, '|') . '))' . b:negateAhead . '"'
highlight default link elvishBuiltinVariable Builtin

syntax match elvishBoolean "$true" contained
syntax match elvishBoolean "$false" contained
highlight default link elvishBoolean Boolean

" FIXME: find a way that doesn't conflict with builtins/booleans
"syntax match elvishVariableOp '\v([$])' contained
"highlight default link elvishVariableOp elvishVariable
" FIXME: should this be a statement?
syntax match elvishRestArgOp '\v([\@])' contained
highlight default link elvishRestArgOp Statement

execute 'syntax match elvishRestArg'
  \ '"\v\@' . b:bareWord . '"'
  \ 'contains='
    \ 'elvishRestArgOp'
highlight default link elvishVariableAccess elvishVariable
execute 'syntax match elvishVariableAccess'
  \ '"\v' . b:negateBehind . '[$]%[\@]' . b:bareWord . '%[\~]' . '"'
  \ 'contains='
    \ 'elvishBoolean,'
    \ 'elvishBuiltinVariable,'
    \ 'elvishRestArgOp'
    "\ 'elvishVariableOp'
highlight default link elvishVariableAccess elvishVariable
highlight default link elvishVariable Normal
syntax cluster elvishVariable
  \ contains=
    \ elvishVariableAccess

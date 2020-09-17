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

let b:bareChar = '\%(\w\|[-]\)'
let b:bareWord = '\%(' . b:bareChar . '\+\)'
let b:negateBehind = '\%(' . b:bareChar . '\|[&.=*<>:]\)\@<!'
let b:negateAhead =  b:bareChar . '\@!'

syntax keyword elvishStatement fn nextgroup=elvishFunction skipwhite
syntax keyword elvishStatement break continue return

syntax keyword elvishBuiltinCommand
  \ all
  \ assoc
  \ base
  \ bool
  \ cd
  \ constantly
  \ count
  \ dir-history
  \ dissoc
  \ drop
  \ each
  \ eawk
  \ echo
  \ esleep
  \ eval-symlinks
  \ exec
  \ exit
  \ external
  \ fail
  \ fclose
  \ fg
  \ float64
  \ fopen
  \ from-json
  \ from-lines
  \ get-env
  \ has-env
  \ has-external
  \ has-key
  \ has-prefix
  \ has-suffix
  \ has-value
  \ keys
  \ kind-of
  \ make-map
  \ multi-error
  \ nop
  \ ns
  \ one
  \ only-bytes
  \ only-values
  \ order
  \ path-abs
  \ path-base
  \ path-clean
  \ path-dir
  \ path-ext
  \ peach
  \ pipe
  \ pprint
  \ prclose
  \ print
  \ pprint
  \ put
  \ pwclose
  \ range
  \ rand
  \ randint
  \ read-line
  \ read-upto
  \ repeat
  \ repr
  \ resolve
  \ run-parallel
  \ search-external
  \ set-env
  \ show
  \ styled
  \ styled-segment
  \ slurp
  \ spawn
  \ src
  \ take
  \ tilde-abbr
  \ time
  \ to-json
  \ to-lines
  \ to-string
  \ unset-env
  \ wcswidth
  \ -gc
  \ -ifaddrs
  \ -is-dir
  \ -log
  \ -override-wcwidth
  \ -source
  \ -stack
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

" FIXME: else conflict, need region
syntax keyword elvishConditional if elif else
" FIXME: else conflict, need region
syntax keyword elvishRepeat for while else
" FIXME: else conflict, need region
syntax keyword elvishException try except else finally
syntax keyword elvishInclude use

syntax match elvishBoolean "$true" display
syntax match elvishBoolean "$false" display

" TODO: negatives, floats, scientific notation
syntax match elvishNumber '\([&\$]\)\@<!\<\d\>' display
syntax match elvishNumber '\([&\$]\)\@<!\<[1-9][0-9]*\d\>' display

syntax match elvishNumberHex '\<0[xX][0-9a-fA-F]*\x\>' display

" FIXME: should only be whitespace chars
let b:cmdAhead = '\%(\s\|\n\)'
execute 'syntax match elvishOperatorArithmetic'
  \ '"' . b:negateBehind . '\(+\|-\|/\|%\|*\)' . b:cmdAhead . '"'

syntax match elvishOperatorAssignment '\(=\)'

execute 'syntax match elvishOperatorComparison'
  \ '"' . b:negateBehind . '\(eq\|not-eq\|is\|<\%[s]\|>\%[s]\|<=\%[s]\|>=\%[s]\|[!]=\%[s]\|==\%[s]\)' . b:cmdAhead . '"'

execute 'syntax match elvishOperatorLogical'
  \ '"' . b:negateBehind . '\(and\|or\|not\)' . b:cmdAhead . '"'

" FIXME: !
syntax match elvishOperatorOther '\(;\||\|?\|,\|&\|*\)'

" FIXME: would be nice to not implement this per-language
syntax keyword elvishTodo
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
  \ contained

syntax match elvishComment "#.*$" display contains=elvishTodo

syntax match elvishFunction "\%(^\s*fn\s\+\)\@<=\%(\w\|-\)*"

syntax match  elvishDeref contained "\%(\\\\\)*\\[\\"'`$(){}#]"
syntax cluster elvishDerefList  contains=elvishDeref
syntax match  elvishVariableAccess "\$\%(@\|\)[a-zA-Z0-9_-]*"
  \ contains=
    \ elvishBoolean,
    \ elvishBuiltinVariable
  \ nextgroup=@elvishDerefList
" XXX: using elvishOperator here may cause unwanted matches.
syntax match elvishVariableAssignment "[a-zA-Z0-9:_-]*[ ]*\ze="
  \ nextgroup=elvishOperator

" FIXME: implement missing escapes
syntax match elvishStringEscape '\(\\["n]\)' contained
syntax region elvishString matchgroup=elvishStringDelimiter start='["]' end='["]'
  \ contains=
    \ elvishStringEscape
syntax match elvishStringEscapeSingle "\(['][']\)" contained
syntax region elvishString matchgroup=elvishStringDelimiter start="[']"  end="[']\%([']\)\@!"
  \ contains=
    \ elvishStringEscapeSingle

syntax region elvishCommandSubstitution start="(" end=")"
  \ contains=
    \ elvishBoolean,
    \ elvishBuiltinCommand,
    \ elvishBuiltinVariable,
    \ elvishComment,
    \ elvishMap,
    \ elvishNumber,
    \ elvishOperator,
    \ elvishOperatorKeyword,
    \ elvishString,
    \ elvishVariableAccess,
    \ elvishVariableAssignment

syntax region elvishScope start="{" end="}"
  \ contains=
    \ elvishBoolean,
    \ elvishBuiltinCommand,
    \ elvishBuiltinVariable,
    \ elvishComment,
    \ elvishConditional,
    \ elvishException,
    \ elvishFunction,
    \ elvishMap,
    \ elvishNumber,
    \ elvishOperator,
    \ elvishOperatorKeyword,
    \ elvishRepeat,
    \ elvishStatement,
    \ elvishString,
    \ elvishVariableAccess,
    \ elvishVariableAssignment

" FIXME: Map key highlighting will currently terminate if the value contains
"        a `]`.  Need a way to negate matching empty map initialization
"        e.g. `[&]`, without terminating highlighting.
syntax region elvishMapKey matchgroup=Operator start="&\(\(\s\+\|\)]\)\@!" end="="
syntax region elvishMap start="\[" end="]"
  \ contains=
    \ elvishBoolean,
    \ elvishBuiltinVariable,
    \ elvishCommandSubstitution,
    \ elvishMapKey,
    \ elvishNumber,
    \ elvishOperator,
    \ elvishString,
    \ elvishVariableAccess

highlight default link elvishBoolean Boolean
highlight default link elvishBuiltinCommand Builtin
highlight default link elvishBuiltinVariable Builtin
highlight default link elvishComment Comment
highlight default link elvishConditional Conditional
highlight default link elvishException Exception
highlight default link elvishFunction Function
highlight default link elvishInclude Include
highlight default link elvishMapKey FunctionArgument
highlight default link elvishNumber Number
highlight default link elvishNumberHex Number
highlight default link elvishOperator Operator
highlight default link elvishOperatorArithmetic Operator
highlight default link elvishOperatorAssignment Operator
highlight default link elvishOperatorComparison Operator
highlight default link elvishOperatorLogical Operator
highlight default link elvishOperatorOther Operator
highlight default link elvishRepeat Repeat
highlight default link elvishStatement Statement
highlight default link elvishString String
highlight default link elvishStringDelimiter String
highlight default link elvishStringEscape Constant
highlight default link elvishStringEscapeSingle Constant
highlight default link elvishVariableAccess elvishVariable
highlight default link elvishVariableAssignment elvishVariable
highlight default link elvishVariable Normal
highlight default link elvishTodo Todo


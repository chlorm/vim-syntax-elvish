" Copyright (c) 2018-2019, Cody Opel <codyopel@gmail.com>
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

" Slower, but prevents some elements from not being highlighted when scrolling.
syntax sync fromstart

syntax keyword elvishStatement fn nextgroup=elvishFunction skipwhite
syntax keyword elvishStatement break continue return

" FIXME: Don't highlight if proceeded by a $ or &
syntax keyword elvishBuiltinCommand
  \ all
  \ assoc
  \ base
  \ cd
  \ chr
  \ constantly
  \ count
  \ dissoc
  \ drop
  \ each
  \ eawk
  \ echo
  \ eq
  \ esleep
  \ exec
  \ exit
  \ explode
  \ external
  \ fail
  \ fclose
  \ fg
  \ fopen
  \ joins
  \ keys
  \ nop
  \ ns
  \ ord
  \ peach
  \ pipe
  \ pprint
  \ prclose
  \ print
  \ put
  \ pwclose
  \ range
  \ rand
  \ randint
  \ repeat
  \ replaces
  \ repr
  \ resolve
  \ slurp
  \ spawn
  \ splits
  \ src
  \ take
  \ wcswidth
syntax match elvishBuiltinCommand "dir-history"
syntax match elvishBuiltinCommand "eval-symlinks"
syntax match elvishBuiltinCommand "from-lines"
syntax match elvishBuiltinCommand "from-json"
syntax match elvishBuiltinCommand "get-env"
syntax match elvishBuiltinCommand "has-env"
syntax match elvishBuiltinCommand "has-external"
syntax match elvishBuiltinCommand "has-key"
syntax match elvishBuiltinCommand "has-prefix"
syntax match elvishBuiltinCommand "has-suffix"
syntax match elvishBuiltinCommand "has-value"
syntax match elvishBuiltinCommand "kind-of"
syntax match elvishBuiltinCommand "multi-error"
syntax match elvishBuiltinCommand "only-bytes"
syntax match elvishBuiltinCommand "only-values"
syntax match elvishBuiltinCommand "path-abs"
syntax match elvishBuiltinCommand "path-base"
syntax match elvishBuiltinCommand "path-clean"
syntax match elvishBuiltinCommand "path-dir"
syntax match elvishBuiltinCommand "path-ext"
syntax match elvishBuiltinCommand "run-parallel"
syntax match elvishBuiltinCommand "search-external"
syntax match elvishBuiltinCommand "set-env"
syntax match elvishBuiltinCommand "styled\(-segment\|\)"
syntax match elvishBuiltinCommand "tilde-abbr"
syntax match elvishBuiltinCommand "to-json"
syntax match elvishBuiltinCommand "to-lines"
syntax match elvishBuiltinCommand "to-string"
syntax match elvishBuiltinCommand "unset-env"
syntax match elvishBuiltinCommand "-gc"
syntax match elvishBuiltinCommand "-ifaddrs"
syntax match elvishBuiltinCommand "-is-dir"
syntax match elvishBuiltinCommand "-log"
syntax match elvishBuiltinCommand "-override-wcwidth"
syntax match elvishBuiltinCommand "-source"
syntax match elvishBuiltinCommand "-stack"
syntax match elvishBuiltinCommand "-time"
syntax match elvishBuiltinVariable "$_"
syntax match elvishBuiltinVariable "$after-chdir"
syntax match elvishBuiltinVariable "$args"
syntax match elvishBuiltinVariable "$before-chdir"
syntax match elvishBuiltinVariable "$E"
syntax match elvishBuiltinVariable "$ok"
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

syntax keyword elvishOperatorKeyword and bool is or
syntax match elvishOperatorKeyword "not\(-eq\|\)"
syntax match elvishOperator
  \ '\%(except\s\+\|[a-zA-Z0-9_=*\-]\)\@<!\%(+\|-\|/\|%\|\^\|!\|?\||\)\%([a-zA-Z0-9_=*\-]\)\@!'
  \ contained
syntax match elvishOperator
  \ '\(!\|+\|-\|\)=\(=\|\)\(s\|\)\|\(>\|<\)\(=\|\)\(s\|\)\|>=' contained
syntax match elvishOperator ';\|&\|,\|*'

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

syn match  elvishDeref contained "\%(\\\\\)*\\[\\"'`$(){}#]"
syn cluster elvishDerefList  contains=elvishDeref
syn match  elvishVariableAccess "\$\%(@\|\)[a-zA-Z0-9_-]*"
  \ nextgroup=@elvishDerefList
" XXX: using elvishOperator here may cause unwanted matches.
syntax match elvishVariableAssignment "[a-zA-Z0-9:_-]*[ ]*\ze="
  \ nextgroup=elvishOperator

syntax region elvishString matchgroup=elvishStringDelimiter start=+"+ end=+"+
syntax region elvishString matchgroup=elvishStringDelimiter start=+'+ end=+'+

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

" Vim regex is kinda backwards from perl regex
" `\(&\)\@<=` would be `(?<=&)` in perl
syntax match elvishMapKey '\%(&\)\@<=\%([0-9a-zA-Z_\-]*\)\%(=\)\@='
syntax region elvishMap start="\[" end="]"
  \ contains=
    \ elvishBoolean,
    \ elvishBuiltinVariable,
    \ elvishCommandSubstitution,
    \ elvishMapKey,
    \ elvishNumber,
    \ elvishOperator,
    \ elvishString,
    \ elvishVariableAccess,
    \ elvishVariableAssignment

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
highlight default link elvishOperatorKeyword Operator
highlight default link elvishRepeat Repeat
highlight default link elvishStatement Statement
highlight default link elvishString String
highlight default link elvishStringDelimiter String
highlight default link elvishVariableAccess elvishVariable
highlight default link elvishVariableAssignment elvishVariable
highlight default link elvishVariable Normal
highlight default link elvishTodo Todo


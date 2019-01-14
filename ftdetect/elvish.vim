" Copyright (c) 2018, Cody Opel <codyopel@gmail.com>
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

function! s:detectElvishShebang()
  " Supports:
  " #!/elvish
  " #! /elvish
  " #!/asdf elvish
  " #! /asdf elvish
  " #!/elvish argv
  if getline(1) =~# '^#!\(\|[ ]\+\)\(/\|/.*/\)\(\|.*\s\+\)elvish\(\|\s\+.*\)$'
    setfiletype elvish
  endif
endfunction

autocmd BufNewFile,BufRead *.elv setfiletype elvish
autocmd BufNewFile,BufRead * call s:detectElvishShebang()


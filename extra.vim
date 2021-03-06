"""""""""""""""""""""""""
" Format
"""""""""""""""""""""""""

fun! FormatDocument()
  if(&ft == 'blade') 
    SpacesClean
    % !npx blade-formatter --stdin --indent-size=2 --wrap=999
  elseif(&ft == 'sql')
    % !sqlformat --reindent --keywords upper --identifiers lower %
  elseif( &ft == 'css' || &ft == 'scss')
    % !npx stylelint --fix
  elseif( &ft == 'markdown')
    PrettierAsync
  elseif(&ft == 'lua') 
    " download https://github.com/JohnnyMorganz/StyLua/releases
    write
    silent !stylua %
    edit
  else
    call CocAction('format')
  endif
endfun

nnoremap <leader>f :call FormatDocument()<Cr>

"""""""""""""""""""""""""
" Fix
"""""""""""""""""""""""""

function! Fix() 
  if(&ft == 'css') 
    % !npx stylelint --fix
  elseif(&ft == 'javascript') 
    silent !npx eslint --fix %
  endif
endfunction 

command! Fix :call Fix() 

"""""""""""""""""""""""""
" Edit Vimrc
"""""""""""""""""""""""""

:command! Vrc e $HOME/.config/vim/basic.vim | e $HOME/.config/vim/plugins.vim | e $HOME/.config/vim/extra.vim
:command! VrcReload so $HOME/.config/vim/basic.vim | so $HOME/.config/vim/plugins.vim | so $HOME/.config/vim/extra.vim

"""""""""""""""""""
" CSS
"""""""""""""""""""

" tc To BEM Class
nnoremap <leader>tb I&__<ESC>A{}<ESC>

fun! s:extractBem()
  " clean
  let @a=''
  " extract
  g/__[a-z-]*/y A
  " new file
  e temp
  " paste
  normal "aP
  " substitute everthing outside capture group and add $ and {}
  %s/.*\(__[a-z-]*\).*/\&\1{}/g
  " yank all
  normal ggyG
  " no highlight
  :nohlsearch
  " exit
  bd!
  " echo
  " echo 'copied to clipboard'
endfun

:command! ExtractBem :call s:extractBem()

""""""""""""""""""""""
" Extract images
""""""""""""""""""""""
command! -nargs=1 ExtractImagesFromUrl :r!curl -s <args> | grep -shoP 'http[^" ]+(jpg|png)'

""""""""""""""""""""""""""""""""""
" Markdown
""""""""""""""""""""""""""""""""""

" Search for hours
" set hlsearch
" command! SearchHours1 /\d\+\.\d\+h
:command! HoursSearch /\d*\.*\d\+h

""""""""""""""""""""""""""""""""
" Css convert to rem:
""""""""""""""""""""""""""""""""
command! Pxtorem s#\v(\d+)px#\=string(submatch(1)/16.0)."rem"
command! Pxtoremglobal %s#\v(\d+)px#\=string(submatch(1)/16.0)."rem"

""""""""""""
" Macros "
""""""""""""

" PHP construct args to class attributes
command! PhpConstructorArgsProcess delmarks z | exec('norm mzlywOpublic $pa;`zjo$this->pa=$pa;`z')

""""""""""""""""""""
" CSS Dictionaries
""""""""""""""""""""

fun! DictionaryDistStylesApp()
  !grep '{' dist/styles/app.css | sed 's/\.//g; s/{//g; s/}//g; s/\\//g' | sort -u > .cssdict
  set dictionary+=.cssdict
endfun
command! DictionaryDistStylesApp :call DictionaryDistStylesApp()

" Generate Boostrap dictionary:
" ctags -R --fields=+aimlS --languages=css --exclude=node_modules -f - | cut -f1 | uniq | sed 's/\.//' > ~/.vim/dict/bootstrap
" Download boostrap and generate classes:
" curl -s https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.css | egrep '{' | egrep -o '\.[a-z0-9:-]+' | sed 's/\.//g' | sort -u > ~/.vim/dict/bootstrap4
:command! DictBoostrap4 :set dictionary+=~/.vim/dict/bootstrap4
:command! DictBoostrap4Remove :set dictionary-=~/.vim/dict/bootstrap4


" Tailwind dictionary
" mkdir -p ~/.vim/dict
" https://tailwindcss.com/docs/installation#using-tailwind-without-post-css
" npx tailwindcss-cli@latest build -o ~/.vim/dict/tailwind.css
" cat ~/.vim/dict/tailwind.css | egrep '{' | egrep -o '\.[a-z0-9:-]+' | sed 's/\.//g' | sort -u > ~/.vim/dict/tailwind
:command! DictTailwind :set dictionary+=~/.vim/dict/tailwind
:command! DictTailwindRemove :set dictionary-=~/.vim/dict/tailwind

"""""""""""""""
" PHP
"""""""""""""""

:command! Lararoutes 0,$d | read !php artisan route:list
:command! -nargs=1 Lararoutegrep read !php artisan route:list | grep <args>
:command! LaravelRouteResourceExplicit :normal 0iroute::WWyiwg;a"viwguea('WWWWyiWg;Pla,'WWWWWWWWyiWg;Pf)a->name('WWWWWWyiWg;Pf)a;lD
:command! CommentsHtmlToLaravel :%s/<!--\(.*\)-->/{{-- \1 --}}

function! PhpToBlade()
  s/<?php/{{/e
  s/?>/}}/e
  s/echo//e
  s/;}/}/e
  s/; }/ }/e
  s/esc_attr_e/_e/e
  s/esc_html_e/_e/e
endfunction
command! PhpToBlade :call PhpToBlade()

command! PhpVarToItemVar :norm viwoaitem['ea']

command PhpIfToBlade :norm 0f{%S@endifD0:s/<?php if/@if

"""""""""""""""
" html
"""""""""""""""

command! LoremHtml :r!curl -Ns https://loripsum.net/api/10/medium/headers/decorate/link/ul/ol/bq/

"""""""""""""""
" Tailwind
"""""""""""""""

:command! TailwindOnTheRight :vsplit | vertical resize 40 | e tailwind.config.js | norm <c-w>h<cr>

"""""""""""""""""""""""""
" Open script
"""""""""""""""""""""""""

" Search on relevant directories
command! Clientes :Files ~/clientes
command! Colegas :Files ~/colegas
command! Conocimiento :Files ~/conocimiento
command! Proyectos :Files ~/proyectos
command! Repos :Files ~/repos
command! Scripts :Files ~/scripts

""""""""""""""""""""
" general settings "
""""""""""""""""""""
" enable syntax highlighting
syntax enable

" enable file type detection
" enable file type specific plugin loading
" enable file type specific indentation
filetype plugin indent on

" set encoding
set encoding=UTF-8

" turn on spell checking by default
set spell spelllang=en_us,de_at

" make command completion work as intuitiv
set wildmode=longest,list,full

" make vim use the system clipboard
set clipboard+=unnamedplus

" enable the mouse
set mouse=a

" enable 24 bit RBG colors
set termguicolors

" enable absolute line numeration for the line the cursor is on
" enable relative line numeration for all other lines relative to the current line
set number relativenumber

" disable default mode indication because vim-airline plugin already displays it
set noshowmode

" disable default cursor line and column information indication because vim-airline plugin already displays it
set noruler



"""""""""""""""""""
" indent settings "
"""""""""""""""""""
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smarttab
set autoindent



"""""""""""""""""""""""""""""""""""""""""
" file extension specific auto commands "
"""""""""""""""""""""""""""""""""""""""""
augroup fileTypeAutoCmdGroup
	" clear this group to prevent duplicates
	autocmd!

	" disable automatic commenting on newline for every file
	" this must be set via autocmd so that it can not be overwrite by plugins
	autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
augroup END



""""""""""""""""""""""""""
" on write auto commands "
""""""""""""""""""""""""""
augroup writeAutoCmdGroup
	" clear this group to prevent duplicates
	autocmd!

	" store the cursors current position as initial position
	autocmd BufWritePre * let initialPosition = getpos(".")

	" automatically remove trailing white space from each line
	autocmd BufWritePre * %s/\s\+$//e

	" automatically remove trailing newlines from the end of the file
	autocmd BufWritePre * %s/\n\+\%$//e

	" automatically add one trailing newline for files with these extensions
	autocmd BufWritePre *.c %s/\%$/\r/e
	autocmd BufWritePre *.h %s/\%$/\r/e
	autocmd BufWritePre *.py %s/\%$/\r/e

	" move the cursor back to it's initial position
	autocmd BufWritePre * cal cursor(initialPosition[1], initialPosition[2])
augroup END



"""""""""""""""""""
" command aliases "
"""""""""""""""""""
" save file as sudo
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!



"""""""""""""""""""""""""""""""
" plugin manager installation "
"""""""""""""""""""""""""""""""
if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif



""""""""""""""""""""""""
" plugins installation "
""""""""""""""""""""""""
call plug#begin()
	" looks plugins
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	Plug 'Mofiqul/dracula.nvim'
	Plug 'ryanoasis/vim-devicons'
	" feature plugins
	Plug 'preservim/nerdtree'
	Plug 'tpope/vim-surround'
	" latex plugins
	Plug 'lervag/vimtex'
call plug#end()



"""""""""""""""""""""""""
" plugins configuration "
"""""""""""""""""""""""""
" vim-airline plugin configuration
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'

" vim-airline-themes plugin configuration
let g:airline_theme='base16_dracula'

" vimtex plugin configuration
let g:vimtex_view_method = $READER



"""""""""""""""""""
" leader mappings "
"""""""""""""""""""
let mapleader=" "
let maplocalleader=","



"""""""""""""
" key binds "
"""""""""""""
" key binding for placeholders
" no delete command is being used so that the copy register is not filled with \"<++>\"
nnoremap <leader><leader> /<CR>llla<Backspace><Backspace><Backspace><Backspace>

" key bindings for NERDTree
nnoremap <C-e> :NERDTreeToggle<CR>

" key bindings for spell checking
nnoremap <leader>se :setlocal spell spelllang=en_us<CR>
nnoremap <leader>sd :setlocal spell spelllang=de_at<CR>
nnoremap <leader>sa :setlocal spell spelllang=en_us,de_at<CR>
nnoremap <leader>sc :setlocal nospell<CR>

" key bindings for commands
nnoremap <leader>cr :%s//g<Left><Left>

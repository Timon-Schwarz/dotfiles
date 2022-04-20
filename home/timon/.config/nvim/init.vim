" set variables
set number
set relativenumber
set autoindent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smarttab
set mouse=a
set encoding=UTF-8
set termguicolors
set wildmode=longest,list,full
set clipboard=unnamedplus

" let variables
let mapleader=" "

" auto commands
" remove trailing whitespace
auto BufWritePre * %s/\s\+$//e

" plugins
call plug#begin()
	" general purpose plugins
	Plug 'https://github.com/vim-airline/vim-airline'
	Plug 'https://github.com/preservim/nerdtree'
	" theming
	Plug 'Mofiqul/dracula.nvim'
	Plug 'vim-airline/vim-airline-themes'
	" markdown plugins
	Plug 'godlygeek/tabular'
	Plug 'preservim/vim-markdown'
call plug#end()

" vim-markdown plugin settings
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_conceal = 0
let g:tex_conceal = ""
let g:vim_markdown_math = 1
let g:vim_markdown_frontmatter = 1  " for YAML format

" vim-airline plugin settings
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'

" vim-airline-themes plugin settings
let g:airline_theme='base16_dracula'

" keybinds
nnoremap <C-s> :w
nnoremap <C-q> :wq
nnoremap <C-e> :NERDTreeToggle<CR>
nnoremap <C-p> :!compile %:p && openOutput %:p<CR>
nnoremap <leader>s :setlocal spell! spelllang=en_us<CR>

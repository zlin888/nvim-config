" set runtimepath^=~/.vim runtimepath+=~/.vim/after
" let &packpath = &runtimepath
" source ~/.vimrc
"
" Remove ALL autocommands for the current group.
autocmd! 
set nocompatible              " be iMproved, required
set number
filetype off                  " required
syntax on
set tabstop=2 softtabstop=2 shiftwidth=2
set expandtab
" let mapleader=" "
set backspace=indent,eol,start
set shell=zsh
set noswapfile
set guifont=Hack\ Nerd\ Font:h12
set clipboard+=unnamedplus

call plug#begin()
" ============== OLD ==============
Plug 'skywind3000/asyncrun.vim' " to async build compiler
Plug 'ctrlpvim/ctrlp.vim'
Plug 'rking/ag.vim'
Plug 'preservim/tagbar' " :Tagbar and show cur function name in status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ludovicchabant/vim-gutentags' " auto generate ctags file, doesn't work together with Tagbar
Plug 'easymotion/vim-easymotion' " jump with keystroke
Plug 'voldikss/vim-floaterm' " this is getting buggy
" ============== OLD ==============

" ============== LSP ==============
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
" 
Plug 'whonore/Coqtail' " for ftdetect, syntax, basic ftplugin, etc
Plug 'tomtomjhj/coq-lsp.nvim'

Plug 'Julian/lean.nvim'

" ============== LSP END ==============

Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}
Plug 'skywind3000/asyncrun.vim' " to async build compiler

" BETTER BUF
Plug 'j-morano/buffer_manager.nvim'
Plug 'famiu/bufdelete.nvim'

Plug 'nvim-tree/nvim-web-devicons' " buffer bar: OPTIONAL: for file icons
Plug 'lewis6991/gitsigns.nvim' " buffer bar: OPTIONAL: for git status
Plug 'romgrk/barbar.nvim' " buffer bar

" AUTO CMP
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
" AUTO COMP For luasnip users.
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

" TELESCOPE SEARCH
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' }

" GIT
Plug 'kdheepak/lazygit.nvim'
Plug 'sindrets/diffview.nvim'
Plug 'f-person/git-blame.nvim'

" SCHEME
Plug 'Shatur/neovim-ayu'

" DIRETORY TREE
Plug 'preservim/nerdtree'

" JUMP
Plug 'pechorin/any-jump.vim'

" Codeforce
Plug 'MunifTanjim/nui.nvim'        " it's a dependency
Plug 'xeluxee/competitest.nvim'

call plug#end()


lua require("mason").setup()
lua require("mason-lspconfig").setup { ensure_installed = { "lua_ls", "pyright", "clangd", "rust_analyzer", "coq_lsp" }, automatic_enable = true }
lua require("toggleterm").setup()
lua require('telescope').load_extension('fzf')
lua require('ayu').colorscheme()
lua require("common")
lua require("lsp")
lua require('competitive_coding_mode')

source ~/.config/nvim/compiler.vim

nnoremap <Leader>vs :source ~/.config/nvim/init.vim<CR>
nnoremap <Leader>ve :e ~/.config/nvim/init.vim<CR>

nnoremap <Leader>tf <Cmd>Telescope find_files<CR>
nnoremap <Leader>tg <Cmd>Telescope live_grep<CR>

" term
set hidden
lua require("term")
nnoremap <silent><Leader>fv <Cmd>exe v:count1 . "ToggleTerm direction=vertical insert_mapping=true size=35"<CR>
nnoremap <silent><Leader>fh <Cmd>exe v:count1 . "ToggleTerm direction=horizontal insert_mapping=true size=10"<CR>


" ========= OLD VIM CONFIG ==========

" VIM CONFIG ITSELF
imap jj <ESC>
" nnoremap <Tab> :bnext<CR>
" nnoremap <S-Tab> :bp<CR>
nnoremap <Leader>x :BufferDelete<CR>

 "NERD TREE (disabled for using nvim native)
nnoremap <Leader>n :NERDTreeFocus<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

nnoremap <Leader>tb :<C-u>Tagbar<CR>
let g:airline#extensions#tagbar#flags = 'f' " show full tag hierarchy

nmap s <Plug>(easymotion-overwin-f2)

" AG
nnoremap <Leader>ag :<C-u>Ag --ignore tags 

" FLOAT TERM
nnoremap   <silent>   <Leader>ff    :FloatermNew<CR>
tnoremap   <silent>   <Leader>ff    <C-\><C-n>:FloatermNew<CR>
nnoremap   <silent>   <Leader>fp    :FloatermPrev<CR>
tnoremap   <silent>   <Leader>fp    <C-\><C-n>:FloatermPrev<CR>
nnoremap   <silent>   <Leader>fn    :FloatermNext<CR>
tnoremap   <silent>   <Leader>fn    <C-\><C-n>:FloatermNext<CR>
nnoremap   <silent>   <Leader>fk   :FloatermKill<CR>
tnoremap   <silent>   <Leader>fk  <C-\><C-n>:FloatermKill<CR>
nnoremap   <silent>   <Leader>ft   :FloatermToggle<CR>
tnoremap   <silent>   <Leader>ft   <C-\><C-n>:FloatermToggle<CR>



" setup mapping to call :LazyGit
nnoremap <silent> <leader>lg :LazyGit<CR>

" ANYJUMP
" Normal mode: Jump to definition under cursor
nnoremap <leader>j :AnyJump<CR>
" Visual mode: jump to selected text in visual mode
xnoremap <leader>j :AnyJumpVisual<CR>
" Normal mode: open previous opened file (after jump)
nnoremap <leader>ab :AnyJumpBack<CR>
" Normal mode: open last closed search window again
nnoremap <leader>al :AnyJumpLastResults<CR>

" yank current (abs) file path
nnoremap <leader>cp: let @" = expand("%:p")<CR>

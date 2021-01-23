call plug#begin('~/.vim/plugged')
  Plug 'szw/vim-maximizer'
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
  Plug 'tpope/vim-commentary'
  Plug 'sbdchd/neoformat'
  Plug 'kassio/neoterm'
  Plug 'itchyny/vim-gitbranch'
  Plug 'itchyny/lightline.vim'
  Plug 'tpope/vim-fugitive'
  Plug 'neovim/nvim-lspconfig'
  Plug 'nvim-lua/completion-nvim'
  Plug 'janko/vim-test'
  Plug 'puremourning/vimspector'
  Plug 'vimwiki/vimwiki'
  Plug 'https://github.com/tomasiser/vim-code-dark'
  Plug 'pangloss/vim-javascript'
  "Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " Once tree sitter works better:
call plug#end()
 
set completeopt=menuone,noinsert,noselect
set mouse=a
set splitright
set splitbelow
set tabstop=2
set shiftwidth=2
set expandtab
set statusline=%f
set number
set ignorecase
set smartcase
set diffopt+=vertical
set hidden
set nobackup
set nowritebackup
set cmdheight=1
set shortmess+=c
set signcolumn=yes
colorscheme codedark
filetype plugin indent on

let mapleader = " "

if (has("termguicolors"))
 set termguicolors
endif

nmap <leader>v :vs $MYVIMRC<CR>

let g:netrw_banner=0

let g:markdown_fenced_languages = ['javascript', 'js=javascript', 'json=javascript']

let g:neoterm_default_mod = 'vertical'
let g:neoterm_size = 100
let g:neoterm_autoinsert = 1

nnoremap <c-f> :Ttoggle<CR>
inoremap <c-f> <Esc>:Ttoggle<CR>
tnoremap <c-f> <c-\><c-n>:Ttoggle<CR>
 
fun! GotoWindow(id)
  :call win_gotoid(a:id)
endfun

let g:vimspector_base_dir = expand('$HOME/.config/vimspector-config')
let g:vimspector_sidebar_width = 120
let g:vimspector_bottombar_height = 0

func! AddToWatch()
  let word = expand("<cexpr>")
  call vimspector#AddWatch(word)
endfunction

nnoremap <leader>m :MaximizerToggle!<CR>
nnoremap <leader>da :call vimspector#Launch()<CR>
nnoremap <leader>dd :TestNearest -strategy=jest<CR>
nnoremap <leader>dc :call GotoWindow(g:vimspector_session_windows.code)<CR>
nnoremap <leader>dv :call GotoWindow(g:vimspector_session_windows.variables)<CR>
nnoremap <leader>dw :call GotoWindow(g:vimspector_session_windows.watches)<CR>
nnoremap <leader>ds :call GotoWindow(g:vimspector_session_windows.stack_trace)<CR>
nnoremap <leader>do :call GotoWindow(g:vimspector_session_windows.output)<CR>
nnoremap <leader>d? :call AddToWatch()<CR>
nnoremap <leader>dx :call vimspector#Reset()<CR>
nnoremap <leader>dX :call vimspector#ClearBreakpoints()<CR>
nnoremap <S-k> <Plug>VimspectorStepOut
nnoremap <S-l> <Plug>VimspectorStepInto
nnoremap <S-j> <Plug>VimspectorStepOver
nnoremap <leader>d_ <Plug>VimspectorRestart
nnoremap <leader>dn :call vimspector#Continue()<CR>
nnoremap <leader>drc <Plug>VimspectorRunToCursor
nnoremap <leader>dh <Plug>VimspectorToggleBreakpoint
nnoremap <leader>de <Plug>VimspectorToggleConditionalBreakpoint

nnoremap <silent> tt :TestNearest<CR>
nnoremap <silent> tf :TestFile<CR>
nnoremap <silent> ts :TestSuite<CR>
nnoremap <silent> t_ :TestLast<CR>

function! JestStrategy(cmd)
  let testName = matchlist(a:cmd, '\v -t ''(.*)''')[1]
  call vimspector#LaunchWithSettings( #{ configuration: 'jest', TestName: testName } )
endfunction      

let test#strategy = "neovim"
let test#neovim#term_position = "vertical"
let g:test#custom_strategies = {'jest': function('JestStrategy')}

nnoremap <leader>gg :G<cr>
nnoremap <leader>gb :G branch<cr>
nnoremap <leader>gd :G diff<cr>
nnoremap <leader>gl :G log -100<cr>
 
if has('nvim')
  au! TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
  au! FileType fzf tunmap <buffer> <Esc>
endif
 
nnoremap <leader><space> :GFiles<CR>
nnoremap <leader>fh :History:<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>ff :Ag<CR>

lua << EOF
local lspconfig = require'lspconfig'
local configs = require'lspconfig/configs'
configs.sapcds_lsp = {
  default_config = {
    cmd = {vim.fn.expand("$HOME/projects/startcdslsp")};
    filetypes = {'cds'};
    root_dir = function(fname)
      return lspconfig.util.find_git_ancestor(fname) or vim.loop.os_homedir()
    end;
    settings = {};
  };
}
if lspconfig.sapcds_lsp.setup then
  lspconfig.sapcds_lsp.setup{ on_attach=require'completion'.on_attach }
end

lspconfig.tsserver.setup{ on_attach=require'completion'.on_attach }
EOF

nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gh     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gH    <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gR    <cmd>lua vim.lsp.buf.rename()<CR>

nnoremap <leader>F :Neoformat prettier<CR>

let g:neoformat_enabled_python = ['prettierstandard']
let g:neoformat_javascript_prettierstandard = {
            \ 'exe': 'prettier-standard',
            \ 'replace': 1
            \ }

let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'gitbranch#name'
      \ },
      \ 'colorscheme': 'codedark',
      \ }

augroup MyCDSCode
    autocmd!
    autocmd BufReadPre,FileReadPre *.cds set ft=cds
augroup END

inoremap <expr> <c-x><c-f> fzf#vim#complete#path(
    \ "find . -path '*/\.*' -prune -o -print \| sed '1d;s:^..::'",
    \ fzf#wrap({'dir': expand('%:p:h')}))

nmap <Leader>tl <Plug>VimwikiToggleListItem
vmap <Leader>tl <Plug>VimwikiToggleListItem
nmap <Leader>wn <Plug>VimwikiNextLink

let g:vimwiki_global_ext = 0
let wiki = {}
let wiki.nested_syntaxes = { 'js': 'javascript' }
let g:vimwiki_list = [wiki] 

" colorscheme nvcode
" Enable once tree sitter works better
"lua <<EOF
"require'nvim-treesitter.configs'.setup {
  "highlight = {
    "enable = true,
  "},
  "incremental_selection = {
    "enable = true,
    "keymaps = {
      "init_selection = "gnn",
      "node_incremental = "gni",
    "},
  "},
  "indent = {
    "enable = true
  "}
"}
"EOF

"set foldmethod=expr
"setlocal foldlevelstart=99
"set foldexpr=nvim_treesitter#foldexpr()

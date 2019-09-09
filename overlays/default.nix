self: super:
{
  st = super.st.overrideAttrs (oldAttrs: rec {
    src = super.fetchFromGitHub {
      owner = "jhaasdijk";
      repo = "st";
      rev = "master";
      sha256 = "0gbv8s2l8h8vysr6200dk69f06lwaa5z5c3cxdxc2icpldylq2sy";
    };
  });

  neovim = super.neovim.override ({
    configure = {
      customRC = ''
        "---------- General ----------"
        set number
        set mouse=a
        set incsearch
        set ruler
        set cursorline
        set colorcolumn=80
        set encoding=utf-8
        filetype plugin indent on
        set scrolloff=5
        set shiftwidth=4
        set tabstop=4
        set expandtab
        set showmatch
        set noshowmode
        "---------- Bindings ----------"
        nnoremap <C-up> <C-Y>
        nnoremap <C-k> <C-Y>
        nnoremap <C-down> <C-E>
        nnoremap <C-j> <C-E>
        map <C-n> <plug>NERDTreeTabsToggle<CR>
        command Pdfrun execute "silent !pandoc --filter pandoc-citeproc -o %.pdf %" | redraw!
        map <F5> :Pdfrun<CR>
        vmap <C-c> :w !xclip -i -sel c
        "---------- Theming ----------"
        colorscheme Tomorrow-Night-Bright
        set laststatus=1
        syntax on
        hi clear CursorLine
        hi CursorLine gui=underline cterm=underline
        hi VertSplit ctermfg=5 ctermbg=bg
        let g:lightline = {
          \ 'colorscheme': 'powerline',
          \ 'active': {
          \   'left': [ [ 'mode', 'paste' ],
          \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
          \ },
          \ 'component_function': {
          \   'gitbranch': 'fugitive#head'
          \ },
          \ 'separator': { 'left': '', 'right': '' },
          \ 'subseparator': { 'left': '|', 'right': '|' },
          \ }
        "---------- Latex ----------"
        let g:livepreview_previewer = 'zathura'
        "---------- GoYo ----------"
        let g:goyo_width  = "50%+20%"
        let g:goyo_height = "100%-5%"
        "---------- Programming ----------"
        au BufNewFile,BufRead *.js, *.html, *.css
          \ set tabstop=2 |
          \ set softtabstop=2 |
          \ set shiftwidth=2
        "---------- Python ----------"
        let python_highlight_all=1
        set foldmethod=indent
        set foldlevel=99
        nnoremap <space> za
        let g:SimpylFold_docstring_preview=1
        let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree
        au BufNewFile,BufRead *.py
          \ set tabstop=4 |
          \ set softtabstop=4 |
          \ set shiftwidth=4 |
          \ set textwidth=79 |
          \ set expandtab |
          \ set autoindent |
          \ set fileformat=unix
        hi BadWhitespace ctermbg=darkgreen guibg=darkgreen
        au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/
      '';
	  plug.plugins = with super.vimPlugins; [
        auto-pairs
        base16-vim
        goyo
        lightline-vim
        nerdtree
        tabular
        vim-colorschemes
        vim-gitgutter
        vim-latex-live-preview
        vim-markdown
        vim-nerdtree-tabs
        vim-polyglot
        vim-sensible
        vim-surround
      ];
    };
  });
}

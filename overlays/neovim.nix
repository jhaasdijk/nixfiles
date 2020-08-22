self: super:
{
  neovim = super.neovim.override ({
    configure = {
      customRC = ''

        "" General

        set autoindent                 " Auto-indent new lines
        set backspace=indent,eol,start " Backspace behaviour
        set cindent                    " Use 'C' style program indenting
        set colorcolumn=80             " Highlight a vertical screen column
        set cursorline                 " Highlight the screen line of the cursor
        set hlsearch                   " Highlight all search results
        set ignorecase                 " Always case-insensitive
        set incsearch                  " Searches for strings incrementally
        set linebreak                  " Break lines at word (requires Wrap lines)
        set mouse=a                    " Enables mouse support in all modes
        set number                     " Show line numbers
        set ruler                      " Show row and column ruler information
        set scrolloff=5                " Minimal number of lines of context
        set shiftwidth=4               " Number of auto-indent spaces
        set showbreak=+++              " Wrap-broken line prefix
        set showmatch                  " Highlight matching brace
        set showtabline=2              " Show tab bar
        set smartcase                  " Enable smart-case search
        set smartindent                " Enable smart-indent
        set softtabstop=4              " Number of spaces per Tab
        set smarttab                   " Enable smart-tabs
        set textwidth=120              " Line wrap (number of cols)
        set undolevels=1000            " Number of undo levels
        set virtualedit=block          " Enable free-range cursor
        set visualbell                 " Use visual bell (no beeping)


        "" Bindings

        nnoremap <C-down> <C-E>
        nnoremap <C-j> <C-E>
        nnoremap <C-k> <C-Y>
        nnoremap <C-up> <C-Y>
        vmap <C-c> :w !xclip -i -sel c

        nnoremap <space> za
        set foldlevel=99
        set foldmethod=indent


        "" Theming

        colorscheme Tomorrow-Night-Bright
        hi BadWhitespace ctermbg=darkgreen guibg=darkgreen
        hi clear CursorLine
        hi CursorLine gui=underline cterm=underline
        hi VertSplit ctermfg=5 ctermbg=bg
        set laststatus=1
        set noshowmode
        syntax on

      '';
      plug.plugins = with super.vimPlugins; [
        auto-pairs       # Edit ({["''"]}) in pairs
        tabular          # Text filtering and alignment
        vim-colorschemes # Extensive colorscheme pack
        vim-gitgutter    # Git diff in the gutter
        vim-polyglot     # Extensive language pack
      ];
    };
  });
}

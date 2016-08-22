" To disable a plugin, add it's bundle name to the following list
let g:pathogen_disabled = []
call add(g:pathogen_disabled, 'omnisharp-vim')
execute pathogen#infect()
syntax on
filetype plugin indent on

" Set up shell indentation to not indent cases
if !exists("b:sh_indent_options")
  let b:sh_indent_options = {}
endif

let b:sh_indent_options['case-labels'] = 0

if &term =~ '256color'
  " disable Background Color Erase (BCE) so that color schemes
  " render properly when inside 256-color tmux and GNU screen.
  " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif

"This ensures that the contents of the clipboard are written to the system
"clipboard on leaving vim
autocmd VimLeave * call system("xsel -ib", getreg())
"Disable swap files they are annoying
set noswapfile
"Enable backup - they are useful
set backup
au BufWritePre * let &bex = '-' . strftime("%Y%m%d-%H%M%S") . '.vimbackup'
set backupdir=~/vimtmp,.

command -nargs=1 -complete=help Help help <args> | only

" Setup the following abbreviations to use this approac for reliability
" :cabbrev e <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'E' : 'e')<CR>
cabbrev he Help
cabbrev hel Help
cabbrev help Help

"After disabling paste mode maybe i can get this to work
" General settings
fu! FullscreenHelp(topic)
    EXecute 'help '.a:topic.' | only'
endf
"Alter help so that it opens in a full window
"allow backspacing over everything in insert mode mainly for comapatability some systems dont support this by default
set backspace=indent,eol,start
set ruler              " show the cursor position all the time
set number             " line numbers
set relativenumber            " show relative numbers
set showcmd
set incsearch
set hlsearch
"Don't ask to save when changing buffers (i.e. when jumping to a type definition)
set hidden
"Stops auto indentation when psting code but also breaks command mappings and
"insert mappings - dont use it!i!!!!
"set paste
"This causes the vim yank/paste to use the X11 copy paste buffer
set clipboard=unnamedplus
"Set tabs to be tabs and set vim to add them automatically while inserting text
set tabstop=4
set shiftwidth=4
set noexpandtab
"this makes sure that there are x lines of context above/below point scrolled to
set scrolloff=8

"statusline
set laststatus=2        "always show the statusline
set statusline=%F       "tail of the filename
set statusline+=[%{strlen(&fenc)?&fenc:'none'}, "file encoding
set statusline+=%{&ff}] "file format
set statusline+=%h      "help file flag
set statusline+=%m      "modified flag
set statusline+=%r      "read only flag
set statusline+=%y      "filetype
set statusline+=%=      "left/right separator
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file

" This sets the textwidth automatically for markdown files (README.md)
au BufRead,BufNewFile *.md setlocal textwidth=80

"This ensures that text that is pasted over in visual mode does not
"overwrite the last yanked text
"check if the cursor is at the end of the line col(".") == col("$")-1
"vnoremap p "_dhp  
"
"Ensure quickfix always open at always bottom
autocmd FileType qf wincmd J
"pgup / pgdown move too far to track text easily but ctrl-d and ctrl-u are hard to reach and not comfy
map <PageUp> <C-U>
map <PageDown> <C-D>
nnoremap <C-H> :<C-U>bp<CR>
nnoremap <C-L> :<C-U>bn<CR>

"Align by columns
command Column %!column -t

"Look more at this - these commadns sort of working - http://stackoverflow.com/questions/7614546/vim-cursorline-color-change-in-insert-mode
"set cursorline
"autocmd InsertEnter * highlight CursorLine guifg=white guibg=blue ctermfg=white ctermbg=blue
"autocmd InsertLeave * highlight CursorLine guifg=white guibg=black ctermfg=white ctermbg=darkblue
"Good article on statusline config
"http://www.blaenkdenum.com/posts/a-simpler-vim-statusline/

"Attempt to change cursor color
"if &term =~ "xterm\\|rxvt"
"    "use an orange cursor in insert mode
"    let &t_SI = "\<Esc>]12;orange\x7"
"    " use a red cursor otherwise
"    let &t_EI = "\<Esc>]12;grey\x7"
"    silent !echo -ne "\033]12;grey\007"
"    " reset cursor when vim exits
"    autocmd VimLeave * silent !echo -ne "\033]112\007"
"    " use \003]12;gray\007 for gnome-terminal and rxvt up to
"   " version 9.21
"endif
"
"if &term =~ '^xterm\\|rxvt'
"    solid underscore
"    let &t_SI .= "\<Esc>[4 q"
"    " solid block
"    let &t_EI .= "\<Esc>[2 q"
"    " 1 or 0 -> blinking block
"    " 3 -> blinking underscore
"    " Recent versions of xterm (282 or above) also support
"    " 5 -> blinking vertical bar
"    " 6 -> solid vertical bar
"endif
"load arpeggio
call arpeggio#load()
let g:arpeggio_timeoutlen=100
" having colon is a pain in the arse for most ex commands so use semicolon
"nmap <Plug>(arpeggio-default::) ;
            "nnoremap <Plug>(arpeggio-default:;) :
"nnoremap <Plug>(arpeggio-default:;) :
Arpeggio inoremap df  <Esc>
"Not really sure that this is necessary in
"since i only go into visual to do specific things
"and those thing end with a yank paste or insert which exits visual
"Arpeggio vnoremap df  <Esc>
Arpeggio cnoremap df  <C-c>
Arpeggio inoremap DF  <Esc>
"Arpeggio vnoremap DF  <Esc>
Arpeggio cnoremap DF  <C-c>
Arpeggio inoremap jk  <Cr>
Arpeggio cnoremap jk  <Cr>
Arpeggio nnoremap jk  <Cr>
Arpeggio nmap lk 15k
Arpeggio nmap ds 15j

"
"Autocomplete with ctrl space
" Next three lines are to enable C-Space to autocomplete, omnicomplete
"inoremap <C-Space> <C-x><C-o>
"imap <Nul> <C-Space>
"smap <Nul> <C-Space

"or this but both seem to fail
function! Auto_complete_string()
    if pumvisible()
        return "\<C-n>"
    else
        return "\<C-x>\<C-o>\<C-r>=Auto_complete_opened()\<CR>"
    end
endfunction

function! Auto_complete_opened()
    if pumvisible()
        return "\<Down>"
    end
    return ""
endfunction
"ctrl spacce can map to these 2 things depending on the term
inoremap <expr> <Nul> Auto_complete_string()

"Easymotion mappings
"It seems that we need to use recursive mappins for easymotion commands
"nonrecursive mappings have no effect
let g:EasyMotion_do_mapping = 0 " Disable default mappings
" Set keys for easymotion to use for jump targets
let g:EasyMotion_keys = 'abcdefghipqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789;,.§'
" we need to map s in this way to avoid a clash with ds
nmap <Plug>(arpeggio-default:s) <Plug>(easymotion-s)
"vmap <Plug>(arpeggio-default:s) <Plug>(easymotion-s)
"Map bi directional line motion
Arpeggio nmap ;l <Plug>(easymotion-bd-jk)
Arpeggio vmap ;l <Plug>(easymotion-bd-jk)
"nmap <Plug>(arpeggio-default::) 
nnoremap <Plug>(arpeggio-default:;) :
vnoremap <Plug>(arpeggio-default:;) :
nnoremap : ;            
vnoremap : ;            
vmap s <Plug>(easymotion-s)
"nmap f <Plug>(easymotion-f)
"nmap F <Plug>(easymotion-F)
"End
" maps the command :w!! to save the current file with sudo permissions
cmap w!! %!sudo tee > /dev/null %
" Open nerdtree by default
"autocmd vimenter * NERDTree

"Close easily
autocmd BufEnter * call CloseVimWhenEditableFilesClosed()
function! CloseVimWhenEditableFilesClosed()
    "echom "BufEnterBegin"
    let windows = winnr('$')
    " more than just nerd tree and quickfix open so return
    if windows > 2
        return
    endif
    let i = 1
    while i <= windows
        "echom "". i .": buftype'". getbufvar(winbufnr(i), '&buftype')."'"
        if getbufvar(winbufnr(i), '&buftype') == ''
            "this is an editable buffer so return
            "echom "BufEnterEnd"
            return
        endif
        let i += 1
    endwhile
    "all buffers uneditable so close
    "echom "BufEnterEnd"
    qa
endfunction

" Open nerd tree if no file
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
noremap <F5> :NERDTreeToggle<CR>
noremap <F6> :NERDTreeFind<CR>
" Dont do this it causes a lot of issues as many keys have esc as part of their key codes
"noremap <Esc> :wincmd w<CR>
nnoremap <Plug>(arpeggio-default:d) d
nnoremap <Plug>(arpeggio-default:f) f
Arpeggio nnoremap df :wincmd w <CR> 


" If the current buffer has never been saved, it will have no name,
" call the file browser to save it, otherwise just save it.
"command! -nargs=0 -bar Update if &modified 
"                           \|    if empty(bufname('%'))
"                           \|        browse confirm write
"                           \|    else
"                           \|        confirm write
"                           \|    endif
"                           \|endif
""the <C-u> kills any current command that may be on the commandline
"nnoremap <C-s> :<C-u>Update<CR>

"Got to set this leader before trying to reference <Leader> anywhere
let mapleader = "," 
nmap <Leader>x :<C-u>Explore<CR>
" Golang
" for filetypes matching go set these commands
"au FileType go nmap <F5> :%!goimports<CR>:%!gofmt<CR>
" the <Leader> actually just resolves to the mapleader variable set earlier
"
" Ok it seems that noremapping have not been defined for plug
" commands so noremap does not work for plug but we need to use it to
" protect against our mapping of the colon to semicolon
" Turn on case insensitive feature
"nnoremap <Plug>(arpeggio-default:a) a
"nnoremap <Plug>(arpeggio-default:u) u
"nnoremap <Plug>(arpeggio-default:i) i
let g:EasyMotion_smartcase = 1
au FileType go nmap <Leader>d <Plug>(go-doc-browser)
au FileType go nmap <leader>s <Plug>(go-implements)
au Filetype go nmap <leader>i <Plug>(go-info)
au Filetype go nmap <leader>e <Plug>(go-rename)
au Filetype go nmap <Leader>c <Plug>(go-referrers)
au FileType go nmap <leader>o <Plug>(go-coverage)
au FileType go nmap <Leader>gd <Plug>(go-doc)
au FileType go nmap <Leader>gd <Plug>(go-doc)
au FileType go noremap <leader>b :w<bar>GoInstall <Cr>
au FileType go noremap <leader>v :w<bar>GoVet <Cr>
au FileType go noremap <Leader>r :w<bar>GoRun<CR>
au FileType go noremap <leader>t :w<bar>GoTest<CR>
au FileType go Arpeggionnoremap ui :w<bar>GoInstall <Cr>
au FileType go noremap <F7> :TagbarToggle<CR>
"au FileType go Arpeggio nmap df <Plug>(go-def)
let g:go_fmt_command = "goimports"
"Set type info for word under cursor to automatically display
let g:go_auto_type_info = 1
let g:go_list_type = "quickfix"
" End

" Omnisharp
"This is the default value, setting it isn't actually necessary
let g:OmniSharp_host = "http://localhost:2000"

"Set the type lookup function to use the preview window instead of the status line
"let g:OmniSharp_typeLookupInPreview = 1

"Timeout in seconds to wait for a response from the server
let g:OmniSharp_timeout = 1

"Showmatch significantly slows down omnicomplete
"when the first match contains parentheses.
set noshowmatch

"Super tab settings - uncomment the next 4 lines
"let g:SuperTabDefaultCompletionType = 'context'
"let g:SuperTabContextDefaultCompletionType = "<c-x><c-o>"
"let g:SuperTabDefaultCompletionTypeDiscovery = ["&omnifunc:<c-x><c-o>","&completefunc:<c-x><c-n>"]
"let g:SuperTabClosePreviewOnPopupClose = 1

"don't autoselect first item in omnicomplete, show if only one item (for preview)
"remove preview if you don't want to see any documentation whatsoever.
set completeopt=longest,menuone  ",preview
" Fetch full documentation during omnicomplete requests.
" There is a performance penalty with this (especially on Mono)
" By default, only Type/Method signatures are fetched. Full documentation can still be fetched when
" you need it with the :OmniSharpDocumentation command.
" let g:omnicomplete_fetch_documentation=1

"Move the preview window (code documentation) to the bottom of the screen, so it doesn't move the code!
"You might also want to look at the echodoc plugin
set splitbelow

" Get Code Issues and syntax errors for c# editing
let g:syntastic_mode_map = {
        \ "mode": "passive", 
        \ "active_filetypes": ["cs"],
        \ "passive_filetypes": [] }

"let g:syntastic_cs_checkers = ['syntax', 'semantic', 'issues']
"" If you are using the omnisharp-roslyn backend, use the following
"" let g:syntastic_cs_checkers = ['code_checker']
"augroup omnisharp_commands
"    autocmd!
"
"    "Set autocomplete function to OmniSharp (if not using YouCompleteMe completion plugin)
"    autocmd FileType cs setlocal omnifunc=OmniSharp#Complete
"
"    " Synchronous build (blocks Vim)
"    "autocmd FileType cs nnoremap <F5> :wa!<cr>:OmniSharpBuild<cr>
"    " Builds can also run asynchronously with vim-dispatch installed
"    autocmd FileType cs nnoremap <leader>b :wa!<cr>:OmniSharpBuildAsync<cr>
"    " automatic syntax check on events (TextChanged requires Vim 7.4)
"    autocmd BufEnter,TextChanged,InsertLeave *.cs SyntasticCheck
"
"    " Automatically add new cs files to the nearest project on save
"    autocmd BufWritePost *.cs call OmniSharp#AddToProject()
"
"    "show type information automatically when the cursor stops moving
"    autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()
"
"    "The following commands are contextual, based on the current cursor position.
"
"    autocmd FileType cs nnoremap gd :OmniSharpGotoDefinition<cr>
"    autocmd FileType cs nnoremap <leader>fi :OmniSharpFindImplementations<cr>
"    autocmd FileType cs nnoremap <leader>ft :OmniSharpFindType<cr>
"    autocmd FileType cs nnoremap <leader>fs :OmniSharpFindSymbol<cr>
"    autocmd FileType cs nnoremap <leader>fu :OmniSharpFindUsages<cr>
"    "finds members in the current buffer
"    autocmd FileType cs nnoremap <leader>fm :OmniSharpFindMembers<cr>
"    " cursor can be anywhere on the line containing an issue
"    autocmd FileType cs nnoremap <leader>x  :OmniSharpFixIssue<cr>
"    autocmd FileType cs nnoremap <leader>fx :OmniSharpFixUsings<cr>
"    autocmd FileType cs nnoremap <leader>tt :OmniSharpTypeLookup<cr>
"    autocmd FileType cs nnoremap <leader>dc :OmniSharpDocumentation<cr>
"    "navigate up by method/property/field
"    autocmd FileType cs nnoremap <C-K> :OmniSharpNavigateUp<cr>
"    "navigate down by method/property/field
"    autocmd FileType cs nnoremap <C-J> :OmniSharpNavigateDown<cr>
"
"augroup END
"
"
"" this setting controls how long to wait (in ms) before fetching type / symbol information.
"set updatetime=500
"" Remove 'Press Enter to continue' message when type information is longer than one line.
"set cmdheight=2
"
"" Contextual code actions (requires CtrlP or unite.vim)
"nnoremap <leader><space> :OmniSharpGetCodeActions<cr>
"" Run code actions with text selected in visual mode to extract method
"vnoremap <leader><space> :call OmniSharp#GetCodeActions('visual')<cr>
"
"" rename with dialog
"nnoremap <leader>nm :OmniSharpRename<cr>
"nnoremap <F2> :OmniSharpRename<cr>
"" rename without dialog - with cursor on the symbol to rename... ':Rename newname'
"command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")
"
"" Force OmniSharp to reload the solution. Useful when switching branches etc.
"nnoremap <leader>rl :OmniSharpReloadSolution<cr>
"nnoremap <leader>cf :OmniSharpCodeFormat<cr>
"" Load the current .cs file to the nearest project
"nnoremap <leader>tp :OmniSharpAddToProject<cr>
"
"" (Experimental - uses vim-dispatch or vimproc plugin) - Start the omnisharp server for the current solution
"nnoremap <leader>ss :OmniSharpStartServer<cr>
"nnoremap <leader>sp :OmniSharpStopServer<cr>
"
"" Add syntax highlighting for types and interfaces
"nnoremap <leader>th :OmniSharpHighlightTypes<cr>
"" End

"Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
"Show errors in one window
let g:syntastic_aggregate_errors = 1
"Disable style warnings - there are way to many! also remove thos pesky Use var messges
let g:syntastic_quiet_messages = { "type": "style",
                                   \ "regex":   '\mUse ''var''' }
" End

" Colors
colorscheme molokai
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
" End
"
" deoplete config
let g:deoplete#enable_at_startup = 1
" disable autocomplete
let g:deoplete#disable_auto_complete = 1
if has("gui_running")
    inoremap <silent><expr> <Nul> deoplete#mappings#manual_complete()
else
    inoremap <silent><expr> <C-@> deoplete#mappings#manual_complete()
endif

"Add mapping to make ctrl space go to next completion option
"<Nul> is interpreted as ctrl-space
"inoremap <Nul> <C-n>
inoremap <C-j> <C-n>
inoremap <C-k> <C-p>
"Ensure that neopairs is adding parenthesis for methods
"call deoplete#custom#set('_', 'converters', ['converter_auto_paren']) "It
"turns out that neopairs parenthesis is kindk of annoying, doesn't work like
"intellij
"utilsnips
let g:UltiSnipsSnippetDirectories=["bundle/vim-go/gosnippets/UtilSnips"]
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.

" If you want :UltiSnipsEdit to split your window.
inoremap <silent><expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"


"let g:EasyClipUseYankDefaults=0
"let g:EasyClipUseCutDefaults=0
"let g:EasyClipUsePasteDefaults=0
"let g:EasyClipEnableBlackHoleRedirect=0
"let g:EasyClipUsePasteToggleDefaults=0


"Neovim likes this here
set spell spelllang=en_gb

" Use relative numbering instead of absolute
set relativenumber

" Fix my frequently wrong typed Wq (etc.) when quiting vim
command WQ wq
command Wq wq
command W w
command Q q

" Map F5 to list and select buffers
nnoremap <F5> :buffers<CR>:buffer<Space>

" Disable Arrow keys in normal, visual and select and operator pending mode (hjkl training)
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" Disable Arrow keys in insert mode (hjkl training)
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>

" Create shortcut for Esc in insert mode
imap jk <esc>
imap kj <esc>

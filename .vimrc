" use relative numbering instead of absolute
set relativenumber

" Fix my frequently wrong typed Wq (etc.) when quiting vim
command WQ wq
command Wq wq
command W w
command Q q

" map F5 to list and select buffers
nnoremap <F5> :buffers<CR>:buffer<Space>

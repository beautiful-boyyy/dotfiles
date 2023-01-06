let mapleader = ' '

set shiftwidth=2
set softtabstop=-1
set tabstop=2
set et
set number
set relativenumber
set scrolloff=5
set clipboard+=unnamed,unnamedplus

" Intelligent case sensitivity
set ignorecase smartcase

" close direction arrow key
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" search 
set hlsearch incsearch
nnoremap <LEADER><CR> :nohlsearch<CR>

" replace word
lua vim.keymap.set('n', '<C-m>', 'cw<C-r>0<ESC>')
" nnoremap <C-m> cw<C-r>0<ESC>

nnoremap S :w<CR>
nnoremap Q :q<CR>
nnoremap R :source $MYVIMRC<CR>
noremap K 7k
noremap H 8h
noremap J 7j
noremap L 8l

" buffer navigation
nnoremap bn :bn<cr>
nnoremap bp :bp<cr>

tnoremap <C-[> <C-\><C-n>

" lua syntax highlighting
let g:vimsyn_embed = 'l'

lua << EOF
function Cmt(opts)
  local str = "\"================  " .. opts.fargs[1] .. "  ================\"";
  vim.fn.setreg('a', str)
  vim.cmd.normal('o')
  vim.cmd.normal('"apo')
  vim.cmd.startinsert();
end

vim.api.nvim_create_user_command('Cmt', Cmt, { nargs = 1 })
EOF

" function CommentTemplate(arg)
" 	let @a = "\"================  " .. a:arg .. "  ================\""
" 	exec 'normal o'
" 	exec 'normal "apo'
"   exec 'normal s'
" 	exec 'startinsert'
" endfunction
" command! -nargs=1 Cmt call CommentTemplate(<f-args>)

"one key to compile and run
lua << EOF
function Run()
  vim.opt.splitbelow = true
  vim.cmd.w()

  if vim.opt.filetype:get() == 'javascript' then
    vim.cmd.split('term://node %')
  elseif vim.opt.filetype:get() == 'typescript' then
    vim.cmd.split('term://tsc %')
  elseif vim.opt.filetype:get() == 'lua' then
    print('hh')
    vim.cmd.split('term://lua %')
  end

end
vim.keymap.set('n', 'r', Run)

EOF

" noremap r :call Run()<CR>
" function! Run()
" 	set splitbelow
" 	exec "w"
" 	if &filetype =='javascript'
" 		:split term://node %
" 	elseif &filetype == 'typescript'
" 		:split term://tsc %
"   elseif &filetype == 'markdown'
"     :InstantMarkdownPreview
"   elseif &filetype == 'lua'
" 		:split term://lua %
"   elseif &filetype == 'c'
"     :split term://gcc % -o %< && ./%<
" 	endif
" endfunction

"================  AUTO EVENTS  ================"
lua << EOF
-- cursor style
  vim.opt.guicursor = 'n-v-c:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor,a:blinkon100'
  
  function hiCursor() 
    vim.api.nvim_set_hl(0, "Cursor", { bg='#660000'})
    vim.api.nvim_set_hl(0, "CursorReset", {fg='white', bg='white'})
  end
  
  vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "*",
      callback = hiCursor,
    })
  
  function cursorReset()
  vim.opt.guicursor = 'a:ver25'
  end
  
  vim.api.nvim_create_autocmd("VimLeave", {
      pattern = "*",
      callback = cursorReset, 
    })

-- transparent
--  function removeBg()
--    vim.api.nvim_set_hl(0, "Normal", { bg = NONE, ctermbg = NONE })
--  end
--
--  vim.api.nvim_create_autocmd("ColorScheme", {
--      pattern = "*",
--      callback = removeBg,
--    })
EOF



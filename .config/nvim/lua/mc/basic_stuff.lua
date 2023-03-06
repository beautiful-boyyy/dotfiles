vim.g.mapleader = ' '
vim.opt.shiftwidth = 2
vim.opt.softtabstop = -1
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 5
vim.opt.clipboard:append { 'unnamed', 'unnamedplus' }

-- Intelligent case sensitivity
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- search
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.keymap.set('n', '<leader><cr>', '<cmd>nohlsearch<cr>')
vim.keymap.set('n', '<C-m>', 'cw<C-r>1<ESC>')

vim.keymap.set('n', 'S', '<cmd>w<CR>')
vim.keymap.set('n', 'Q', '<cmd>q<CR>')
vim.keymap.set({ 'n', 'x' }, 'K', '7k')
vim.keymap.set({ 'n', 'x' }, 'H', '8h')
vim.keymap.set({ 'n', 'x' }, 'J', '7j')
vim.keymap.set({ 'n', 'x' }, 'L', '8l')

-- buffer navigation
vim.keymap.set('n', 'bn', '<cmd>bn<cr>')
vim.keymap.set('n', 'bp', '<cmd>bp<cr>')

vim.keymap.set('t', '<C-[>', [['<C-\><C-n>']])

-- lua syntax highlighting in vimscript
vim.g.vimsyn_embed = 'l'

function Cmt(opts)
  local str = "-- ================  " .. opts.fargs[1] .. "  ================ --";
  vim.fn.setreg('a', str)
  vim.cmd.normal('o')
  vim.cmd.normal('"apo')
  vim.cmd.normal('ciw')
  vim.cmd.startinsert()
end

vim.api.nvim_create_user_command('Cmt', Cmt, { nargs = 1 })

-- one key to compile and run
function Run()
  vim.opt.splitbelow = true
  vim.cmd.w()

  if vim.opt.filetype:get() == 'javascript' then
    vim.cmd.split('term://node %')
  elseif vim.opt.filetype:get() == 'typescript' then
    vim.cmd.split('term://esr %')
  elseif vim.opt.filetype:get() == 'lua' then
    vim.cmd.split('term://lua %')
  elseif vim.opt.filetype:get() == 'markdown' then
    vim.cmd('CocCommand markdown-preview-enhanced.openPreview')
  elseif vim.opt.filetype:get() == 'cpp' then
    vim.cmd.split('term://clang++ -std=c++20 % -o %< && ./%<')
  end

end

vim.keymap.set('n', 'r', Run)

--================  AUTO EVENTS  ================--
-- cursor style
vim.opt.guicursor = 'n-v-c:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor,a:blinkon100'

function HiCursor()
  vim.api.nvim_set_hl(0, "Cursor", { bg = '#660000' })
  vim.api.nvim_set_hl(0, "CursorReset", { fg = 'white', bg = 'white' })
end

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = HiCursor,
})

function CursorReset()
  vim.opt.guicursor = 'a:ver25'
end

vim.api.nvim_create_autocmd("VimLeave", {
  pattern = "*",
  callback = CursorReset,
})

-- transparent
-- function RemoveBg()
--   vim.api.nvim_set_hl(0, "Normal", { })
--   vim.api.nvim_set_hl(0, "NormalFloat", { })
-- end
--
-- vim.api.nvim_create_autocmd("ColorScheme", {
--     pattern = "*",
--     callback = RemoveBg,
--   })

local has = vim.fn.has
local stdpath = vim.fn.stdpath
local nvim_path = stdpath('data') .. '/plugged'
local Plug = vim.fn['plug#']

vim.call('plug#begin', has('nvim') and nvim_path or '~/.vim/plugged')

-- kitty conf syntax highlight
Plug 'fladson/vim-kitty'

-- nvim-treesitter
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' })
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'RRethy/nvim-treesitter-textsubjects'
Plug 'p00f/nvim-ts-rainbow'

-- Highlight arguments' definitions and usages
Plug 'm-demare/hlargs.nvim'

Plug 'kylechui/nvim-surround'

-- better yank
Plug 'gbprod/yanky.nvim'

-- telescope integration
Plug 'nvim-lua/plenary.nvim'
Plug('nvim-telescope/telescope.nvim', { tag = '0.1.0' })
Plug('nvim-telescope/telescope-fzf-native.nvim',
  { ['do'] = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' })
Plug('nvim-telescope/telescope-fzf-native.nvim', { ['do'] = 'make' })
Plug 'barrett-ruth/telescope-http.nvim'
Plug 'LinArcX/telescope-env.nvim'
Plug 'debugloop/telescope-undo.nvim'

-- auto-save
Plug 'Pocco81/auto-save.nvim'

-- project manage
Plug 'ahmedkhalf/project.nvim'

-- file browser
Plug 'luukvbaal/nnn.nvim'

-- mark
Plug 'MattesGroeger/vim-bookmarks'
Plug 'tom-anders/telescope-vim-bookmarks.nvim'
Plug 'ThePrimeagen/harpoon'

-- focus the codes which are editing
Plug 'Pocco81/true-zen.nvim'
Plug 'folke/twilight.nvim'

-- transparent
-- Plug 'xiyaowong/nvim-transparent'

-- theme
Plug 'EdenEast/nightfox.nvim'

-- statusline for nvim
Plug 'nvim-lualine/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'

-- edit support
Plug 'windwp/nvim-ts-autotag'
Plug 'windwp/nvim-autopairs'
Plug 'ethanholz/nvim-lastplace'
Plug 'numToStr/Comment.nvim'
Plug 'JoosepAlviste/nvim-ts-context-commentstring'

-- float term
Plug 'numToStr/FTerm.nvim'
-- coc.nvim
Plug('neoclide/coc.nvim', { ['branch'] = 'release' })

-- hugo
Plug 'phelipetls/vim-hugo'

-- colorizer
Plug 'norcalli/nvim-colorizer.lua'

-- emmet
Plug 'mattn/emmet-vim'

vim.call('plug#end')

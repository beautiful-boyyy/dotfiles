local keyset = vim.keymap.set
local api = vim.api

-- ================  nvim-treesitter  ================ --
require 'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "lua", "javascript", "typescript", "html", "css", "json", "vim", "tsx", "markdown", "yaml", "jsonc", "toml" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  rainbow = {
    enable = true,
    -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = nil, -- Do not enable for files with more than n lines, int
    -- colors = {}, -- table of hex strings
    -- termcolors = {} -- table of colour name strings
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },

  indent = {
    enable = true
  },

  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  }
}

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = vim.call('nvim_treesitter#foldexpr')
vim.opt.foldenable = true

-- ================  nvim-treesitter-textobjects  ================ --

require 'nvim-treesitter.configs'.setup {
  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        -- You can optionally set descriptions to the mappings (used in the desc parameter of
        -- nvim_buf_set_keymap) which plugins like which-key display
        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
        ["ib"] = "@block.inner",
        ["ab"] = "@block.outer",
        ["ia"] = "@call.inner",
        ["aa"] = "@call.outer",
        ["am"] = "@comment.outer",
        ["id"] = "@conditional.inner",
        ["ad"] = "@conditional.outer",
        ["ip"] = "@parameter.inner",
        ["ap"] = "@parameter.outer",
        ["il"] = "@loop.inner",
        ["al"] = "@loop.outer",
        ["as"] = "@statement.outer",
      },
      -- If you set this to `true` (default is `false`) then any textobject is
      -- extended to include preceding or succeeding whitespace. Succeeding
      -- whitespace has priority in order to act similarly to eg the built-in
      -- `ap`.
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * selection_mode: eg 'v'
      -- and should return true of false
      include_surrounding_whitespace = false,
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>p"] = "@parameter.inner",
        ["<leader>f"] = "@function.outer",
      },
      swap_previous = {
        ["<leader>P"] = "@parameter.inner",
        ["<leader>F"] = "@function.outer",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = { query = "@class.outer", desc = "Next class start" },
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
  },
}

-- ================  nvim-treesitter-textsubjects  ================ --
require('nvim-treesitter.configs').setup {
  textsubjects = {
    enable = true,
    prev_selection = ',', -- (Optional) keymap to select the previous selection
    keymaps = {
      ['.'] = 'textsubjects-smart',
      [';'] = 'textsubjects-container-outer',
      ['i;'] = 'textsubjects-container-inner',
    },
  },
}

-- ================  nvim-surround  ================ --
require("nvim-surround").setup {}

-- ================  hlargs.nvim  ================ --
require('hlargs').setup()

-- ================  telescope.nvim  ================ --
keyset('n', '<leader>ff', require('telescope.builtin').find_files)
keyset('n', '<leader>fg', require('telescope.builtin').live_grep)
keyset('n', '<leader>fb', require('telescope.builtin').buffers)
keyset('n', '<leader>fh', require('telescope.builtin').help_tags)
keyset('n', '<leader>fo', require('telescope.builtin').oldfiles)
keyset('n', '<leader>fr', require('telescope.builtin').registers)
keyset('n', '<leader>fc', require('telescope.builtin').command_history)
keyset('n', '<leader>fs', require('telescope.builtin').search_history)
keyset('n', '<leader>fy', require('telescope').extensions.yank_history.yank_history)
keyset('n', '<leader>fp', require('telescope').extensions.projects.projects)
keyset('n', '<leader>fu', require('telescope').extensions.undo.undo)

--- File and text search in hidden files and directories ---

local telescope = require("telescope")
local telescopeConfig = require("telescope.config")

-- Clone the default Telescope configuration
local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

-- I want to search in hidden/dot files.
table.insert(vimgrep_arguments, "--hidden")
-- I don't want to search in the `.git` directory.
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/*")

telescope.setup({
  defaults = {
    -- `hidden = true` is not supported in text grep commands.
    vimgrep_arguments = vimgrep_arguments,
    dynamic_preview_title = true,
  },
  pickers = {
    find_files = {
      -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
      find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
    },
  },
  extensions = {
    undo = {
      side_by_side = true, -- this is the default
      mappings = { -- this whole table is the default
        i = {
          ["<cr>"] = require("telescope-undo.actions").restore,
        },
      },
    },
  },
})

require('telescope').load_extension('fzf')
require('telescope').load_extension('vim_bookmarks')
require('telescope').load_extension 'http'
require('telescope').load_extension('env')
require("telescope").load_extension("yank_history")
require('telescope').load_extension('projects')
require("telescope").load_extension("undo")

-- ================  auto-save.nvim  ================ --
require("auto-save").setup {}

-- ================  twilight.nvim  ================ --
require("twilight").setup {}

-- ================  true-zen.nvim  ================ --
vim.wo.foldmethod = 'manual'
keyset('n', '<leader>zn', '<cmd>TZNarrow<cr>')
keyset("v", '<leader>zn', ":'<,'>TZNarrow<CR>")
keyset('n', '<leader>zf', '<cmd>TZFocus<cr>')
keyset('n', '<leader>zm', '<cmd>TZMinimalist<cr>')
keyset('n', '<leader>za', '<cmd>TZAtaraxis<cr>')

require("true-zen").setup {
  modes = {
    ataraxis = {
      padding = { -- padding windows
        left = 52,
        right = 52,
        top = 0,
        bottom = 0,
      },
      minimum_writing_area = { -- minimum size of main window
        width = 80,
        height = 44,
      },
    },
  },
  integrations = {
    tmux = false, -- hide tmux status bar in (minimalist, ataraxis)
    kitty = { -- increment font size in Kitty. Note: you must set `allow_remote_control socket-only` and `listen_on unix:/tmp/kitty` in your personal config (ataraxis)
      enabled = false,
      font = "+3"
    },
    twilight = true, -- enable twilight (ataraxis)
    lualine = true -- hide nvim-lualine (ataraxis)
  },
}

-- ================  vim-bookmarks  ================ --
vim.g.bookmark_sign = '📝'
vim.g.bookmark_annotation_sign = '📝'
vim.g.bookmark_display_annotation = 1
vim.g.bookmark_show_toggle_warning = 0
vim.g.bookmark_show_warning = 0
vim.g.bookmark_auto_save_file = os.getenv('HOME') .. '/.local/share/nvim/plugged/vim-bookmarks/bookmarks/.vim-bookmarks'

-- ================  telescope-vim-bookmarks.nvim  ================ --
local opt = { hide_filename = false, tail_path = true }
keyset('n', 'ma', function() require('telescope').extensions.vim_bookmarks.all(opt) end)

-- ================  yanky.nvim  ================ --
require("yanky").setup({
  -- your configuration comes here
  -- or leave it empty to use the default settings
  -- refer to the configuration section below
  highlight = {
    timer = 300,
  },
})

keyset({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
keyset({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
keyset({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
keyset({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
keyset("n", "<C-n>", "<Plug>(YankyCycleForward)")
keyset("n", "<C-p>", "<Plug>(YankyCycleBackward)")
keyset("n", "]p", "<Plug>(YankyPutIndentAfterLinewise)")
keyset("n", "[p", "<Plug>(YankyPutIndentBeforeLinewise)")
keyset("n", "]P", "<Plug>(YankyPutIndentAfterLinewise)")
keyset("n", "[P", "<Plug>(YankyPutIndentBeforeLinewise)")
keyset("n", ">p", "<Plug>(YankyPutIndentAfterShiftRight)")
keyset("n", "<p", "<Plug>(YankyPutIndentAfterShiftLeft)")
keyset("n", ">P", "<Plug>(YankyPutIndentBeforeShiftRight)")
keyset("n", "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)")
keyset("n", "=p", "<Plug>(YankyPutAfterFilter)")
keyset("n", "=P", "<Plug>(YankyPutBeforeFilter)")

vim.cmd.highlight { 'link', 'YankyPut', 'PounceAccept' }
vim.cmd.highlight { 'link', 'YankyYanked', 'PounceAccept' }

-- ================  nnn.nvim  ================ --
local builtin = require("nnn").builtin
local function open_in_vsplit(files)
  builtin.open_in_vsplit(files)
  api.nvim_create_autocmd('VimResized', {
    pattern = '*',
    callback = function() vim.cmd('horizontal wincmd =') end,
    once = true
  })
end

local mappings = {
  { "<C-t>", builtin.open_in_tab }, -- open file(s) in tab
  { "<C-s>", builtin.open_in_split }, -- open file(s) in split
  { "<C-v>", open_in_vsplit }, -- open file(s) in vertical split
  { "<C-p>", builtin.open_in_preview }, -- open file in preview split keeping nnn focused
  { "<C-y>", builtin.copy_to_clipboard }, -- copy file(s) to clipboard
  { "<C-w>", builtin.cd_to_path }, -- cd to file directory
  { "<C-e>", builtin.populate_cmdline }, -- populate cmdline (:) with file(s)
}

require("nnn").setup {
  picker = {
    cmd = "nnn -Pp"
  },
  mappings = mappings
}

keyset("n", "<leader>nn", "<cmd>NnnPicker %:p:h<CR>")

-- ================  nvim-transparent  ================ --
require("transparent").setup({})

-- ================  project.nvim  ================ --
require("project_nvim").setup {}

-- ================  nvim-ts-autotag  ================ --
require('nvim-ts-autotag').setup {}

-- ================  nvim-autopairs  ================ --
require("nvim-autopairs").setup {}

-- ================  nvim-lastplace  ================ --
require 'nvim-lastplace'.setup {}

-- ================  Comment.nvim  ================ --
require('Comment').setup {
  pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
}

-- ================  coc.nvim  ================ --
vim.g.coc_node_path = '/usr/local/bin/node'
vim.g.coc_global_extensions = { 'coc-json', 'coc-tsserver', 'coc-eslint', 'coc-css', 'coc-sumneko-lua', 'coc-vimlsp',
  'coc-markdownlint', 'coc-webview', 'coc-svg', 'coc-translator', 'coc-yaml', 'coc-markdown-preview-enhanced', 'coc-toml', 'coc-html', 'coc-htmlhint', 'coc-html-css-support', 'coc-go' }

local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }

function _G.check_back_space()
  local col = vim.fn.col('.') - 1
  return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- Use Tab for trigger completion with characters ahead and navigate
keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

-- Make <CR> to accept selected completion item or notify coc.nvim to format
keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

-- Use `[g` and `]g` to navigate diagnostics
-- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
keyset("n", "[g", "<Plug>(coc-diagnostic-prev)", { silent = true })
keyset("n", "]g", "<Plug>(coc-diagnostic-next)", { silent = true })

-- Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
-- delays and poor user experience
vim.opt.updatetime = 300

-- Always show the signcolumn, otherwise it would shift the text each time
-- diagnostics appeared/became resolved
vim.opt.signcolumn = "yes"

-- GoTo code navigation
keyset("n", "gd", "<Plug>(coc-definition)", { silent = true })
keyset("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
keyset("n", "gi", "<Plug>(coc-implementation)", { silent = true })
keyset("n", "gr", "<Plug>(coc-references)", { silent = true })

-- Symbol renaming
keyset("n", "<leader>rn", "<Plug>(coc-rename)", { silent = true })

-- Highlight the symbol and its references on a CursorHold event(cursor is idle)
api.nvim_create_augroup("CocGroup", {})
api.nvim_create_autocmd("CursorHold", {
  group = "CocGroup",
  command = "silent call CocActionAsync('highlight')",
  desc = "Highlight symbol under cursor on CursorHold"
})

-- coc-translator
keyset({ 'n' }, '<leader>t', '<Plug>(coc-translator-p)')
keyset({ 'v' }, '<leader>t', '<Plug>(coc-translator-pv)')

local function Format(opts)
  vim.call('CocActionAsync', 'format')
end

-- coc-markdownlint
keyset('n', 'mf', '<cmd>CocCommand markdownlint.fixAll<cr>')

api.nvim_create_user_command('Format', Format, {})

-- ================  FTerm.nvim  ================ --
require'FTerm'.setup{}
keyset('n', '<A-i>', '<CMD>lua require("FTerm").toggle()<CR>')
keyset('t', '<A-i>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')

local fterm = require("FTerm")

local fterm_new = fterm:new({
    ft = 'fterm_new', -- You can also override the default filetype, if you want
    cmd = "zsh",
})

vim.keymap.set({'n', 't'}, '<A-j>', function()
    fterm_new:toggle()
end)

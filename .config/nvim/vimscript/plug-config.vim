"================  nvim-treesitter  ================"
lua << EOF
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = {"lua", "javascript", "typescript", "html", "css", "json", "vim", "tsx", "markdown", "yaml"},

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
vim.opt.foldenable = false
EOF

" set foldmethod=expr
" set foldexpr=nvim_treesitter#foldexpr()
" set nofoldenable                     " Disable folding at startup.

"================  nvim-treesitter-textobjects  ================"
lua <<EOF
require'nvim-treesitter.configs'.setup {
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
        ["<leader>f"] =  "@function.outer",
      },
      swap_previous = {
        ["<leader>P"] = "@parameter.inner",
        ["<leader>F"] =  "@function.outer",
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
EOF

"================  nvim-treesitter-textsubjects  ================"
lua << EOF
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
EOF

"================  nvim-surround  ================"
lua require("nvim-surround").setup{}

"================  hlargs.nvim  ================"
lua require('hlargs').setup()

"================  telescope.nvim  ================"
" nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
" nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
" nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
" nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
" nnoremap <leader>fo <cmd>lua require('telescope.builtin').oldfiles()<cr>
" nnoremap <leader>fr <cmd>lua require('telescope.builtin').registers()<cr>
" nnoremap <leader>fc <cmd>lua require('telescope.builtin').command_history()<cr>
" nnoremap <leader>fs <cmd>lua require('telescope.builtin').search_history()<cr>
" nnoremap <leader>fy <cmd>lua require('telescope').extensions.yank_history.yank_history()<cr>
" nnoremap <leader>fp <cmd>lua require('telescope').extensions.projects.projects{}<cr>
" nnoremap <leader>fu <cmd>lua require('telescope').extensions.undo.undo()<cr>
lua << EOF
local keyset = vim.keymap.set
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
EOF

lua << EOF
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
      mappings = {          -- this whole table is the default
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
EOF

"================  auto-save.nvim  ================"
lua << EOF
	require("auto-save").setup {
	}
EOF

"================  twilight.nvim  ================"
lua require("twilight").setup{}

"================  true-zen.nvim  ================"
lua << EOF
  vim.wo.foldmethod = 'manual'

  local api = vim.api

  api.nvim_set_keymap("n", "<leader>zn", ":TZNarrow<CR>", {})
  api.nvim_set_keymap("v", "<leader>zn", ":'<,'>TZNarrow<CR>", {})
  api.nvim_set_keymap("n", "<leader>zf", ":TZFocus<CR>", {})
  api.nvim_set_keymap("n", "<leader>zm", ":TZMinimalist<CR>", {})
  api.nvim_set_keymap("n", "<leader>za", ":TZAtaraxis<CR>", {})

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
EOF

"================  vim-bookmarks  ================"
let g:bookmark_sign = '📝'
let g:bookmark_annotation_sign = '📝'
let g:bookmark_display_annotation = 1
let g:bookmark_show_toggle_warning = 0
let g:bookmark_show_warning = 0
let g:bookmark_auto_save_file = $HOME . '/.local/share/nvim/plugged/vim-bookmarks/bookmarks/.vim-bookmarks'

"================  telescope-vim-bookmarks.nvim  ================"
lua << EOF
local opt = { hide_filename = false, tail_path = true }
vim.keymap.set('n', 'ma', function() require('telescope').extensions.vim_bookmarks.all(opt) end)
EOF

"================  yanky.nvim  ================"
lua << EOF
require("yanky").setup({
  -- your configuration comes here
  -- or leave it empty to use the default settings
  -- refer to the configuration section below
  highlight = {
      timer = 300,
    },
})

vim.keymap.set({"n","x"}, "p", "<Plug>(YankyPutAfter)")
vim.keymap.set({"n","x"}, "P", "<Plug>(YankyPutBefore)")
vim.keymap.set({"n","x"}, "gp", "<Plug>(YankyGPutAfter)")
vim.keymap.set({"n","x"}, "gP", "<Plug>(YankyGPutBefore)")
vim.keymap.set("n", "<C-n>", "<Plug>(YankyCycleForward)")
vim.keymap.set("n", "<C-p>", "<Plug>(YankyCycleBackward)")

vim.keymap.set("n", "]p", "<Plug>(YankyPutIndentAfterLinewise)")
vim.keymap.set("n", "[p", "<Plug>(YankyPutIndentBeforeLinewise)")
vim.keymap.set("n", "]P", "<Plug>(YankyPutIndentAfterLinewise)")
vim.keymap.set("n", "[P", "<Plug>(YankyPutIndentBeforeLinewise)")

vim.keymap.set("n", ">p", "<Plug>(YankyPutIndentAfterShiftRight)")
vim.keymap.set("n", "<p", "<Plug>(YankyPutIndentAfterShiftLeft)")
vim.keymap.set("n", ">P", "<Plug>(YankyPutIndentBeforeShiftRight)")
vim.keymap.set("n", "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)")

vim.keymap.set("n", "=p", "<Plug>(YankyPutAfterFilter)")
vim.keymap.set("n", "=P", "<Plug>(YankyPutBeforeFilter)")
EOF
highlight! default link YankyPut PounceAccept
highlight! default link YankyYanked PounceAccept

"================  nnn.nvim  ================"
lua << EOF
	local builtin = require("nnn").builtin
	mappings = {
		{ "<C-t>", builtin.open_in_tab },       -- open file(s) in tab
		{ "<C-s>", builtin.open_in_split },     -- open file(s) in split
		{ "<C-v>", builtin.open_in_vsplit },    -- open file(s) in vertical split
		{ "<C-p>", builtin.open_in_preview },   -- open file in preview split keeping nnn focused
		{ "<C-y>", builtin.copy_to_clipboard }, -- copy file(s) to clipboard
		{ "<C-w>", builtin.cd_to_path },        -- cd to file directory
		{ "<C-e>", builtin.populate_cmdline },  -- populate cmdline (:) with file(s)
	}
require("nnn").setup{
  picker = {
    cmd = "nnn -Pp"
  },
  mappings = mappings
}
vim.keymap.set("n", "<leader>nn", "<cmd>NnnPicker %:p:h<CR>")
EOF

"================  nvim-transparent  ================"
lua << EOF
require("transparent").setup({
  enable = true, -- boolean: enable transparent
})
EOF

"================  project.nvim  ================"
lua require("project_nvim").setup{}

"================  nvim-ts-autotag  ================"
lua require('nvim-ts-autotag').setup{}

"================  nvim-autopairs  ================"
lua require("nvim-autopairs").setup{}

"================  nvim-lastplace  ================"
lua require'nvim-lastplace'.setup{}

"================  Comment.nvim  ================"
lua << EOF
require('Comment').setup{
  pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
}
EOF

"================  coc.nvim  ================"
lua << EOF
vim.g.coc_global_extensions = { 'coc-json', 'coc-tsserver', 'coc-eslint', 'coc-css', 'coc-sumneko-lua', 'coc-vimlsp'}

local keyset = vim.keymap.set
local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}

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
keyset("n", "[g", "<Plug>(coc-diagnostic-prev)", {silent = true})
keyset("n", "]g", "<Plug>(coc-diagnostic-next)", {silent = true})

-- Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
-- delays and poor user experience
vim.opt.updatetime = 300

-- Always show the signcolumn, otherwise it would shift the text each time
-- diagnostics appeared/became resolved
vim.opt.signcolumn = "yes"

-- GoTo code navigation
keyset("n", "gd", "<Plug>(coc-definition)", {silent = true})
keyset("n", "gy", "<Plug>(coc-type-definition)", {silent = true})
keyset("n", "gi", "<Plug>(coc-implementation)", {silent = true})
keyset("n", "gr", "<Plug>(coc-references)", {silent = true})

-- Symbol renaming
keyset("n", "<leader>rn", "<Plug>(coc-rename)", {silent = true})

-- Highlight the symbol and its references on a CursorHold event(cursor is idle)
vim.api.nvim_create_augroup("CocGroup", {})
vim.api.nvim_create_autocmd("CursorHold", {
    group = "CocGroup",
    command = "silent call CocActionAsync('highlight')",
    desc = "Highlight symbol under cursor on CursorHold"
})

local function Format(opts)
  vim.call('CocActionAsync', 'format')
end
vim.api.nvim_create_user_command('Format', Format, {})
EOF


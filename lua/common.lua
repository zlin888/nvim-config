vim.opt.termguicolors = true
require("bufferline").setup{}

require("buffer_manager").setup({
  select_menu_item_commands = {
    v = {
      key = "<C-v>",
      command = "vsplit"
    },
    h = {
      key = "<C-h>",
      command = "split"
    }
  },
  focus_alternate_buffer = false,
  short_file_names = true,
  short_term_names = true,
  loop_nav = false,
  highlight = 'Normal:BufferManagerBorder',
  win_extra_options = {
    winhighlight = 'Normal:BufferManagerNormal',
  },
})

local bmui = require("buffer_manager.ui")
local map = vim.keymap.set
local opts = {noremap = true}

map({ 't', 'n' }, '<leader>bm', bmui.toggle_quick_menu, opts)
map('n', '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>', opts)
map('n', '<Tab>', '<Cmd>BufferLineCycleNext<CR>', opts)
map('n', '<leader>1', '<Cmd>BufferLineGoToBuffer 1<CR>', opts)
map('n', '<leader>2', '<Cmd>BufferLineGoToBuffer 2<CR>', opts)
map('n', '<leader>3', '<Cmd>BufferLineGoToBuffer 3<CR>', opts)
map('n', '<leader>4', '<Cmd>BufferLineGoToBuffer 4<CR>', opts)
map('n', '<leader>5', '<Cmd>BufferLineGoToBuffer 5<CR>', opts)
map('n', '<leader>6', '<Cmd>BufferLineGoToBuffer 6<CR>', opts)
map('n', '<leader>7', '<Cmd>BufferLineGoToBuffer 7<CR>', opts)
map('n', '<leader>8', '<Cmd>BufferLineGoToBuffer 8<CR>', opts)
map('n', '<leader>9', '<Cmd>BufferLineGoToBuffer 9<CR>', opts)
map('n', '<leader>bd', '<Cmd>BufferLinePickClose<CR>', opts)
map('n', '<leader>bp', '<Cmd>BufferLinePick<CR>', opts)


-- codeforce
require('competitest').setup{
	editor_ui = {
		popup_width = 0.4,
		popup_height = 0.6,
		show_nu = true,
		show_rnu = true,
		normal_mode_mappings = {
			switch_window = { "<C-w-h>", "<C-w-l>"},
			save_and_close = "<C-s>",
			cancel = { "q", "Q" },
		},
		insert_mode_mappings = {
			switch_window = { "<C-w-h>", "<C-w-l>"},
			save_and_close = "<C-s>",
			cancel = "<C-q>",
		},
	},
} -- to use default configuration

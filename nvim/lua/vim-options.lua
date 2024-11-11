-- Set tabs width
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

-- Map leader to space
vim.g.mapleader = " "

-- Set clipboard to allow using win32yank -- https://github.com/equalsraf/win32yank/
vim.opt.clipboard = "unnamedplus"

-- Make line numbers default
vim.wo.relativenumber = true
vim.wo.number = true

-- Set highlight on search
vim.o.hlsearch = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Remove default command line
vim.o.cmdheight = 0

-- General custom keymaps
vim.api.nvim_set_keymap('n', '<leader>q', ':bd!<CR>', { noremap = true, silent = true }) -- Close current buffer
vim.keymap.set('n', '<leader>cp', ':let @+ = expand("%:f")<CR>', {}) -- Copy file path
vim.api.nvim_set_keymap('n', '<leader>ws', [[:lua vim.fn.system('wslview ' .. vim.fn.shellescape(vim.fn.expand('%:p:h'))) <CR>]], { noremap = true }) -- Open Windows explorer in current file path

-- ignore capitalization mistakes
vim.cmd("ca W w")
vim.cmd("ca Q q")
vim.cmd("ca WQ wq")
vim.cmd("ca Wq wq")
vim.cmd("ca WQ wq")
vim.cmd("ca Qa qa")

-- unhilight
vim.keymap.set("n", "<leader>h", ":noh<cr>")

-- Highlight current line
vim.wo.cursorline = true

-- Keep X lines below/above current line
vim.o.scrolloff = 10

-- Hide mode
vim.o.showmode = false

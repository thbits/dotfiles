-- Set tabs width
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

-- Map leader to space
vim.g.mapleader = " "

-- Set clipboard to allow using win32yank
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

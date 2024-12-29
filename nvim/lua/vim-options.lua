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

-- Smart indentation
vim.o.smartindent = true

-- Remove default command line
vim.o.cmdheight = 0

-- General custom keymaps
-- vim.api.nvim_set_keymap('n', '<leader>q', ':bd!<CR>', { noremap = true, silent = true }) -- Close current buffer
vim.api.nvim_set_keymap("n", "<leader>q", ":Bdelete!<CR>", { noremap = true, silent = true }) -- Close current buffer
vim.keymap.set("n", "<leader>cp", ':let @+ = expand("%:f")<CR>', {})                          -- Copy file path
vim.api.nvim_set_keymap(
  "n",
  "<leader>ws",
  [[:lua vim.fn.system('wslview ' .. vim.fn.shellescape(vim.fn.expand('%:p:h'))) <CR>]],
  { noremap = true }
) -- Open Windows explorer in current file path

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

-- Show diagnostics only for current line
vim.diagnostic.config({
  virtual_text = false,
})

local ns = vim.api.nvim_create_namespace("CurlineDiag")
vim.opt.updatetime = 100
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    vim.api.nvim_create_autocmd("CursorHold", {
      buffer = args.buf,
      callback = function()
        pcall(vim.api.nvim_buf_clear_namespace, args.buf, ns, 0, -1)
        local hi = { "Error", "Warn", "Info", "Hint" }
        local curline = vim.api.nvim_win_get_cursor(0)[1]
        local diagnostics = vim.diagnostic.get(args.buf, { lnum = curline - 1 })
        local virt_texts = { { (" "):rep(4) } }
        for _, diag in ipairs(diagnostics) do
          virt_texts[#virt_texts + 1] = { diag.message, "Diagnostic" .. hi[diag.severity] }
        end
        vim.api.nvim_buf_set_extmark(args.buf, ns, curline - 1, 0, {
          virt_text = virt_texts,
          hl_mode = "combine",
        })
      end,
    })
  end,
})

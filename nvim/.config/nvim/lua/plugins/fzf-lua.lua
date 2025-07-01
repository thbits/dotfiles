return {
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("fzf-lua").setup({"max-perf",winopts={preview={default="bat"}}})
			vim.api.nvim_set_keymap('n', '<C-p>', ':FzfLua files<CR>', { noremap = true, silent = true })
			vim.api.nvim_set_keymap('n', '<C-g>', ':FzfLua grep_visual<CR>', { noremap = true, silent = true })
    end
  }
}

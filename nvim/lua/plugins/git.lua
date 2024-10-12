return {
  -- lazygit
  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>lg", "<cmd>LazyGitCurrentFile<cr>", desc = "LazyGit" },
    },
  },
  -- vim-fugitive
  {
    "tpope/vim-fugitive",
  },
  -- diffview
  {
    "sindrets/diffview.nvim",
    config = function()
      require("diffview").setup({
        enhanced_diff_hl = true,
      })
      vim.keymap.set("n", "<leader>gd", ":DiffviewFileHistory %<CR>", {})
      vim.keymap.set("n", "<leader>gdc", ":DiffviewClose<CR>", {})
    end,
  },
}

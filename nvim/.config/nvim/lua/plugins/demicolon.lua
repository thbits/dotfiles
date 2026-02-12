-- Disabled: depends on nvim-treesitter-textobjects which is incompatible with nvim-treesitter rewrite
return {
  "mawkler/demicolon.nvim",
  enabled = false,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  opts = {},
}

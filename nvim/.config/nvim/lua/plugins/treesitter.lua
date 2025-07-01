return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    branch = "main",
    setup = function()
      local config = require("nvim-treesitter.configs")
      config.setup({
        auto_install = true,
        --      ensure_installed = { "lua"},
        highlight = { enabled = true },
        indent = { enabled = true },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
  },
  {
    -- "https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
    "HiPhish/rainbow-delimiters.nvim",
  },
}

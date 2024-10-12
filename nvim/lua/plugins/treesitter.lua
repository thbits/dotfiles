return {
  "nvim-treesitter/nvim-treesitter", build = ":TSUpdate",
  setup = function()
    local config = require("nvim-treesitter.configs")
    config.setup({
      auto_install = true,
--      ensure_installed = { "lua"},
      highlight = { enabled = true },
      indent = { enabled = true },
    })
  end
}

return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    -- add any options here
  },
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    "rcarriga/nvim-notify",
  },
  require("noice").setup({
    cmdline = {
      view = "cmdline",
    },
  }),
  vim.keymap.set("n", "<leader>j", function()
    require("noice").cmd("dismiss")
  end),
}

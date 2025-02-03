return {
  "tzachar/local-highlight.nvim",
  config = function()
    require("local-highlight").setup({
      insert_mode = false,
    })
  end,
}

return {
  "nat-418/boole.nvim",
  config = function()
    require("boole").setup()
    vim.keymap.set("n", "<leader>tt", ":Boole increment<CR>", {})
  end,
}

return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
      -- close_if_last_window = true
      enable_diagnostics = false,
      close_if_last_window = false,
      window = {
        position = "right",
        width = 45,
        auto_expand_width = true,
      },
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
        },
      },
      default_component_configs = {
        name = {
          highlight_opened_files = true,
        },
      },
    })
    vim.keymap.set("n", "<C-e>", ":Neotree filesystem reveal_force_cwd right<CR>", {})
    -- vim.keymap.set("n", "<leader>bb", ":Neotree buffers toggle float reveal<CR>", {})
    vim.keymap.set("n", "<leader>bb", ":Neotree buffers toggle right<CR>", {})
  end,
}

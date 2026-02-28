return {
  "thbits/jeanCode.nvim",
  -- dir = "~/personal/git/jeanCode.nvim",
  cmd = { "JeanCode", "JeanCodeNew", "JeanCodeSend", "JeanCodeLayout" },
  keys = {
    { "<leader>cc", "<cmd>JeanCode<cr>",     desc = "Toggle Claude Code" },
    { "<leader>cs", "<cmd>JeanCodeSend<cr>", mode = "v",                 desc = "Send to Claude" },
  },
  opts = {
    cli = { args = { "--dangerously-skip-permissions", "--mcp-config", vim.fn.expand("$HOME") .. "/.config/mcp.json" } },
  },
  config = function(_, opts)
    require("jeancode").setup(opts)
  end,
}

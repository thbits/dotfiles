-- Disabled: codewindow.nvim is incompatible with current nvim-treesitter
-- (ts_utils module was removed). See https://github.com/gorbit99/codewindow.nvim/issues/86
return {
  "gorbit99/codewindow.nvim",
  enabled = false,
  config = function()
    local codewindow = require("codewindow")
    codewindow.setup()
    codewindow.apply_default_keybinds()
  end,
}
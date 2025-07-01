return {
  "saghen/blink.cmp",
  -- optional: provides snippets for the snippet source
  dependencies = {
    "rafamadriz/friendly-snippets",
    "xzbdmw/colorful-menu.nvim",
  },
  -- use a release tag to download pre-built binaries

  version = "*",
  opts = {
    keymap = {
      preset = "default",
      ['C-l'] = {
        function(cmp)
          vim.schedule(function()
            cmp.show({ providers = { 'snippets' } })
          end)
        end
      },
    },
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "mono",
    },
  },
  config = function()
    local blink_cmp = require("blink.cmp")
    -- Set up blink.cmp
    blink_cmp.setup({
      completion = {
        menu = {
          draw = {
            -- Configure the menu to use colorful-menu components
            columns = { { "kind_icon" }, { "label", gap = 1 } },
            components = {
              label = {
                text = function(ctx)
                  return require("colorful-menu").blink_components_text(ctx)
                end,
                highlight = function(ctx)
                  return require("colorful-menu").blink_components_highlight(ctx)
                end,
              },
            },
          },
        },
      },
    })
  end,
}

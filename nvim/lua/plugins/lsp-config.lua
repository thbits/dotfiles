return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "helm_ls",
          "groovyls",
          "ansiblels",
          "bashls",
          "jinja_lsp",
          "jqls",
          "grammarly",
          "nginx_language_server",
          "vacuum",
          "pyright",
          "terraformls",
          "eslint",
          "spectral",
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      -- local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup({})
      lspconfig.helm_ls.setup({})
      lspconfig.groovyls.setup({
        cmd = { "groovy-language-server" },
      })
      lspconfig.spectral.setup({})
      lspconfig.ansiblels.setup({})
      lspconfig.bashls.setup({})
      lspconfig.jinja_lsp.setup({})
      lspconfig.jqls.setup({})
      lspconfig.grammarly.setup({})
      lspconfig.nginx_language_server.setup({})
      lspconfig.vacuum.setup({})
      lspconfig.pyright.setup({})
      lspconfig.terraformls.setup({})
      lspconfig.eslint.setup({})
      lspconfig.spectral.setup({})
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "<leader>ge", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
    end,
  },
}

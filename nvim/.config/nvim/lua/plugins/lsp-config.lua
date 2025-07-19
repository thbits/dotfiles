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
          -- "docker",
          -- "ansiblels",
          -- "jinja_lsp",
          -- "jqls",
          -- "grammarly",
          "nginx_language_server",
          "vacuum",
          -- "pyright",
          "terraformls",
          -- "eslint",
          -- "spectral",
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "saghen/blink.cmp",
      {
        "folke/lazydev.nvim",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      lspconfig.lua_ls.setup({ capabilities = capabilities })
      lspconfig.helm_ls.setup({ capabilities = capabilities })
      lspconfig.groovyls.setup({
        cmd = { "groovy-language-server" },
      })
      -- lspconfig.spectral.setup({ capabilities = capabilities })
      lspconfig.ansiblels.setup({ capabilities = capabilities })
      lspconfig.jinja_lsp.setup({ capabilities = capabilities })
      lspconfig.jqls.setup({ capabilities = capabilities })
      lspconfig.grammarly.setup({ capabilities = capabilities })
      lspconfig.nginx_language_server.setup({ capabilities = capabilities })
      lspconfig.vacuum.setup({ capabilities = capabilities })
      lspconfig.pyright.setup({ capabilities = capabilities })
      lspconfig.terraformls.setup({ capabilities = capabilities })
      lspconfig.eslint.setup({ capabilities = capabilities })
      lspconfig.yamlls.setup({ capabilities = capabilities })
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "<leader>ge", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local c = vim.lsp.get_client_by_id(args.data.client_id)
          if not c then
            return
          end

          if vim.bo.filetype == "lua" then
            -- Format the current buffer on save
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = args.buf, id = c.id })
              end,
            })
          end
        end,
      })
    end,
  },
}
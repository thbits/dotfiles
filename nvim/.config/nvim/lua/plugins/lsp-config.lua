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
      local ensure_installed = {
        "lua_ls",
        "helm_ls",
        "dockerls",
        "docker_compose_language_service",
        "ansiblels",
        -- "jinja_lsp", -- Not available in Mason
        -- "jqls", -- Not available in Mason
        "ltex", -- LanguageTool LSP for grammar/spell checking (replaces archived grammarly)
        "vacuum",
        "pyright",
        "terraformls",
        "eslint",
        "bashls",
        "jsonls",
        "marksman",
        "taplo",
        -- "spectral",
      }

      local has_supported_nginx_python = vim.fn.executable("python3.12") == 1
        or vim.fn.executable("python3.11") == 1
        or vim.fn.executable("python3.10") == 1
        or vim.fn.executable("python3.9") == 1
      if has_supported_nginx_python then
        table.insert(ensure_installed, "nginx_language_server")
      end

      require("mason-lspconfig").setup({
        ensure_installed = ensure_installed,
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
      -- lspconfig.jinja_lsp.setup({ capabilities = capabilities }) -- Not available in Mason
      -- lspconfig.jqls.setup({ capabilities = capabilities }) -- Not available in Mason
      lspconfig.ltex.setup({
        capabilities = capabilities,
        settings = {
          ltex = {
            language = "en-US",
          },
        },
      })
      if vim.fn.executable("nginx-language-server") == 1 then
        lspconfig.nginx_language_server.setup({ capabilities = capabilities })
      end
      lspconfig.vacuum.setup({ capabilities = capabilities })
      lspconfig.pyright.setup({
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "workspace",
              useLibraryCodeForTypes = true,
              typeCheckingMode = "basic",
            },
          },
        },
        -- Automatically detect and use virtual environment
        on_init = function(client)
          local path = vim.fn.getcwd()
          -- Check for common virtual environment locations
          local venv_paths = {
            path .. "/.venv",
            path .. "/venv",
            path .. "/.virtualenv",
            path .. "/env",
          }
          for _, venv_path in ipairs(venv_paths) do
            if vim.fn.isdirectory(venv_path) == 1 then
              client.config.settings.python.pythonPath = venv_path .. "/bin/python"
              client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
              break
            end
          end
        end,
      })
      lspconfig.terraformls.setup({ capabilities = capabilities })
      lspconfig.eslint.setup({ capabilities = capabilities })
      lspconfig.yamlls.setup({ capabilities = capabilities })
      lspconfig.dockerls.setup({ capabilities = capabilities })
      lspconfig.docker_compose_language_service.setup({ capabilities = capabilities })
      lspconfig.bashls.setup({ capabilities = capabilities })
      lspconfig.jsonls.setup({ capabilities = capabilities })
      lspconfig.marksman.setup({ capabilities = capabilities })
      lspconfig.taplo.setup({ capabilities = capabilities })
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

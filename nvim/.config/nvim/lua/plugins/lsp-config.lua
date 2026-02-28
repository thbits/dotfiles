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
        "ltex",
        "vacuum",
        "pyright",
        "terraformls",
        "eslint",
        "bashls",
        "jsonls",
        "marksman",
        "taplo",
        "yamlls",
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
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- Simple servers with just capabilities
      local simple_servers = {
        "lua_ls",
        "helm_ls",
        "ansiblels",
        "vacuum",
        "terraformls",
        "eslint",
        "dockerls",
        "docker_compose_language_service",
        "bashls",
        "jsonls",
        "marksman",
        "taplo",
      }

      for _, server in ipairs(simple_servers) do
        vim.lsp.config(server, { capabilities = capabilities })
      end

      -- Servers with custom settings
      vim.lsp.config("yamlls", {
        cmd = {
          "yaml-schema-router",
          "--lsp-path",
          vim.fn.stdpath("data") .. "/mason/bin/yaml-language-server",
        },
        capabilities = capabilities,
      })

      vim.lsp.config("groovyls", {
        cmd = { "groovy-language-server" },
        capabilities = capabilities,
      })

      vim.lsp.config("ltex", {
        capabilities = capabilities,
        settings = {
          ltex = {
            language = "en-US",
          },
        },
      })

      vim.lsp.config("pyright", {
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
        on_init = function(client)
          local path = vim.fn.getcwd()
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

      -- Enable all configured servers
      local all_servers = vim.list_extend(simple_servers, { "yamlls", "groovyls", "ltex", "pyright" })
      if vim.fn.executable("nginx-language-server") == 1 then
        vim.lsp.config("nginx_language_server", { capabilities = capabilities })
        table.insert(all_servers, "nginx_language_server")
      end
      vim.lsp.enable(all_servers)

      -- Keymaps
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "<leader>ge", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})

      -- Format lua on save
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local c = vim.lsp.get_client_by_id(args.data.client_id)
          if not c then
            return
          end
          if vim.bo.filetype == "lua" then
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

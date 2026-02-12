return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup()

      -- Add runtime/ subdir to rtp so queries (highlights.scm etc.) are found
      local ts_path = vim.fn.stdpath("data") .. "/lazy/nvim-treesitter/runtime"
      if not vim.list_contains(vim.opt.rtp:get(), ts_path) then
        vim.opt.rtp:prepend(ts_path)
      end

      -- Auto-install missing parsers when entering a buffer
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local ft = vim.bo[args.buf].filetype
          local lang = vim.treesitter.language.get_lang(ft) or ft
          if not pcall(vim.treesitter.language.add, lang) then
            pcall(function()
              require("nvim-treesitter").install({ lang })
            end)
          end
          pcall(vim.treesitter.start, args.buf)
        end,
      })

      -- Enable treesitter highlighting for already-open buffers
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype ~= "" then
          pcall(vim.treesitter.start, buf)
        end
      end

      vim.o.foldmethod = "expr"
      vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.o.foldenable = false
    end,
  },
  -- Disabled: incompatible with nvim-treesitter rewrite (requires removed nvim-treesitter.configs)
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    enabled = false,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
  },
}
return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("lualine").setup({
			options = {
				theme = "catppuccin",
				globalstatus = true, -- Use global status line
				component_separators = "|",
				section_separators = "",
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" }, -- Diagnostics added here
				lualine_c = {
					{
						"buffers",
						show_filename_only = true, -- Show only filenames to save space
						hide_filename_extension = false, -- Show file extensions
						icons_enabled = true, -- Show filetype icons
						buffers_color = {
							active = { fg = "#cdd6f4", bg = "#1e1e2e", gui = "bold" }, -- Active buffer color
							inactive = { fg = "#6c7086", bg = "#1e1e2e" }, -- Inactive buffer color
						},
						symbols = {
							modified = " ●", -- Symbol for modified buffers
							close = " ", -- Close button symbol
						},
						max_length = vim.o.columns * 0.5, -- Allocate 50% of the status line to buffers
					},
				},
				lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			extensions = {},
		})
	end,
}

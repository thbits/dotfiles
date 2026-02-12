return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			integrations = {
				blink_cmp = true,
				diffview = true,
				gitsigns = true,
				indent_blankline = { enabled = true },
				mason = true,
				neotree = true,
				noice = true,
				notify = true,
				rainbow_delimiters = true,
				render_markdown = true,
				snacks = true,
				treesitter_context = true,
			},
		})
		vim.cmd.colorscheme("catppuccin")
	end,
}

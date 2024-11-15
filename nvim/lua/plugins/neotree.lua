return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require("neo-tree").setup({
			-- close_if_last_window = true
			enable_diagnostics = false,
			window = {
				position = "right",
				width = 45,
			},
		})
		vim.keymap.set("n", "<C-e>", ":Neotree filesystem reveal_force_cwd right<CR>", {})
		-- vim.keymap.set("n", "<leader>bb", ":Neotree buffers toggle float reveal<CR>", {})
		vim.keymap.set("n", "<leader>bb", ":Neotree buffers toggle right<CR>", {})
	end,
}

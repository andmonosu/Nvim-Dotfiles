return {
	{
		"elmcgill/springboot-nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
			"mfussenegger/nvim-jdtls",
			"nvim-tree/nvim-tree.lua",
		},
		ft = { "java", "properties", "yaml" },
		config = function()
			-- Inicialización limpia y directa
			require("springboot-nvim").setup({})
		end,
	},
}

return {
	-- El cliente DAP (Debugger)
	{
		"mfussenegger/nvim-dap",
		lazy = true,
		config = function() end,
	},

	-- El plugin nativo de JDTLS
	{
		"mfussenegger/nvim-jdtls",
		ft = { "java" }, -- Solo se carga cuando abres un archivo .java
		dependencies = {
			"mfussenegger/nvim-dap", -- Nos aseguramos de que DAP esté instalado para vincularlo
		},
	},
}

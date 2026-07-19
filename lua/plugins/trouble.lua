return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		-- Usamos tus iconos personalizados de config.icons
		icons = {
			diagnostics = {
				Error = require("config.icons").diagnostics.Error,
				Warn = require("config.icons").diagnostics.Warning,
				Hint = require("config.icons").diagnostics.Hint,
				Info = require("config.icons").diagnostics.Information,
			},
		},
		modes = {
			diagnostics = {
				auto_close = true, -- Se cierra solo si arreglas todos los errores
				filter = {
					any = {
						buf = 0, -- Muestra por defecto los errores del archivo actual
					},
				},
			},
		},
	},
	keys = {
		{
			"<leader>tt",
			"<cmd>Trouble diagnostics toggle<CR>",
			desc = "Trouble: Abrir/Cerrar panel de errores",
		},
		{
			"<leader>ta",
			"<cmd>Trouble diagnostics toggle filter.buf=nil<CR>",
			desc = "Trouble: Ver errores de TODO el proyecto",
		},
		{
			"<leader>tl",
			"<cmd>Trouble loclist toggle<CR>",
			desc = "Trouble: Location List",
		},
		{
			"<leader>tq",
			"<cmd>Trouble qflist toggle<CR>",
			desc = "Trouble: Quickfix List",
		},
	},
}

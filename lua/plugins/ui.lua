return {
	-- 1. 🔔 MOTOR DE NOTIFICACIONES ELEGANTE
	{
		"rcarriga/nvim-notify",
		keys = {
			{
				"<leader>un",
				function()
					require("notify").dismiss({ silent = true, pending = true })
				end,
				desc = "UI: Limpiar notificaciones activas",
			},
		},
		opts = {
			stages = "fade", -- Animación elegante de desvanecimiento
			timeout = 3000, -- Se ocultan solas a los 3 segundos
			top_down = true, -- Empiezan desde arriba hacia abajo (Esquina superior derecha)
			background_colour = "#000000", -- Se adapta al fondo de tu esquema de colores
			icons = {
				ERROR = require("config.icons").diagnostics.Error,
				WARN = require("config.icons").diagnostics.Warning,
				HINT = require("config.icons").diagnostics.Hint,
				INFO = require("config.icons").diagnostics.Information,
			},
		},
		config = function(_, opts)
			local notify = require("notify")
			notify.setup(opts)
			-- Redirige la función nativa de Neovim al plugin elegante
			vim.notify = notify
		end,
	},

	-- 2. 🚀 REDISEÑO DE CMDLINE Y MENSAJES (NOICE)
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify", -- Forzamos a que cargue notify antes
		},
		opts = {
			-- Redirecciones de UI interna
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			-- Configuración de las vistas que pedías
			views = {
				cmdline_popup = {
					position = {
						row = "40%", -- Desplaza el cmdline al centro vertical aproximado
						col = "50%",
					},
					size = {
						width = 60,
						height = "auto",
					},
				},
				popupmenu = {
					relative = "editor",
					position = {
						row = "48%", -- El menú de autocompletado de comandos justo debajo del cmdline centrado
						col = "50%",
					},
					size = {
						width = 60,
						height = 10,
					},
					border = {
						style = "rounded",
						padding = { 0, 1 },
					},
					win_options = {
						winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
					},
				},
			},
			-- Habilitamos los modos visuales que quieres sustituir
			presets = {
				bottom_search = false, -- Falso para que el buscador también sea un popup centrado
				command_palette = true, -- Agrupa el cmdline y el menú en un formato paleta estilizado
				long_message_to_split = true, -- Mensajes muy largos de errores van a un split, no te rompen la pantalla
				inc_rename = false, -- Soporte para cambio de variables incremental si lo usas
				lsp_doc_border = true, -- Bordes redondeados en la documentación flotante de Java/TS
			},
		},
	},
}

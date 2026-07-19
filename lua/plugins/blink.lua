return {
	"saghen/blink.cmp",
	dependencies = {
		"saghen/blink.lib",
		-- optional: provides snippets for the snippet source
		"rafamadriz/friendly-snippets",
	},
	build = function()
		-- build the fuzzy matcher, optionally add a timeout to `pwait(timeout_ms)`
		-- you can use `gb` in `:Lazy` to rebuild the plugin as needed
		require("blink.cmp").build():pwait()
	end,

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		keymap = {
			-- Desactivamos los mapas por defecto para tener control total
			preset = "none",

			-- Definimos nuestros propios atajos de teclado
			["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
			["<C-e>"] = { "hide" },
			["<CR>"] = { "accept", "fallback" },

			-- Navegación con C-j y C-k
			["<C-j>"] = { "select_next", "fallback" },
			["<C-k>"] = { "select_prev", "fallback" },

			-- Desplazamiento en la ventana de documentación
			["<C-b>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },

			-- Navegación de Snippets (saltar entre variables/placeholders)
			["<Tab>"] = { "snippet_forward", "fallback" },
			["<S-Tab>"] = { "snippet_backward", "fallback" },
		},

		-- Opciones visuales recomendadas para una experiencia óptima
		completion = {
			list = {
				selection = {
					-- Evita pre-seleccionar automáticamente el primer elemento al escribir,
					-- requiriendo que uses C-j/C-k o que presiones Enter para confirmar lo seleccionado.
					preselect = false,
					auto_insert = true,
				},
			},
			menu = {
				border = "rounded", -- Bordes redondeados estéticos
			},
			documentation = {
				auto_show = true, -- Muestra la docu automáticamente al navegar
				auto_show_delay_ms = 200,
				window = { border = "rounded" },
			},
		},
		fuzzy = { implementation = "rust" },
	},
}

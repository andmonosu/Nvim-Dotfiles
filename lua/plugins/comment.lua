return {
	"numToStr/Comment.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		-- Maneja comentarios contextuales dentro de archivos mixtos (ej: HTML/CSS dentro de TSX/Vue/Angular)
		"JoosepAlviste/nvim-ts-context-commentstring",
	},
	config = function()
		-- Inicialización previa del plugin de contexto (Requerido por versiones modernas)
		require("ts_context_commentstring").setup({
			enable_autocmd = false,
		})

		-- ⌨️ Mapeos de teclado ultra rápidos usando tu <leader> (Espacio + /)
		vim.keymap.set(
			"n",
			"<leader>/",
			"<Plug>(comment_toggle_linewise_current)",
			{ desc = "Comentar: Alternar línea" }
		)
		vim.keymap.set(
			"v",
			"<leader>/",
			"<Plug>(comment_toggle_linewise_visual)",
			{ desc = "Comentar: Alternar selección" }
		)

		local comment = require("Comment")

		comment.setup({
			-- 🛠️ Integración moderna y limpia para TSX/JSX/Vue/Angular/Svelte
			pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),

			-- 📁 Soporte explícito de comentarios para lenguajes adicionales
			ft_mappings = true,
		})

		-- ✨ Parche específico para QML (Quickshell Linux)
		-- Le dice al plugin que use la sintaxis de comentarios de C/JavaScript en archivos QML
		local ft = require("Comment.ft")
		ft.set("qml", { "// %s", "/* %s */" })
	end,
}

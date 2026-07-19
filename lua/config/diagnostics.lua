-- 🎨 CONFIGURACIÓN DE ICONOS PARA DIAGNÓSTICOS (SÓLO COLUMNA IZQUIERDA)
local icons = require("config.icons")

vim.diagnostic.config({
	-- 1. Activamos e inyectamos tus iconos nativos en la barra lateral
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
			[vim.diagnostic.severity.WARN] = icons.diagnostics.Warning,
			[vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
			[vim.diagnostic.severity.INFO] = icons.diagnostics.Information,
		},
	},
	-- 2. Desactivamos por completo el texto que sale al final de la línea
	virtual_text = false,

	-- 3. Mantenemos el subrayado fino debajo del código afectado
	underline = true,

	-- Opciones de comportamiento interno estándar
	update_in_insert = false,
	severity_sort = true,
})

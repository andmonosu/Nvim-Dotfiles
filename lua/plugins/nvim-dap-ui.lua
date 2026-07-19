return {
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			-- 1. Inicialización estándar del plugin
			dapui.setup({})

			-- 2. Automatización: Escuchar eventos de DAP para abrir/cerrar la interfaz
			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end

			-- 3. Atajo manual extra (por si acaso cierras un panel sin querer)
			vim.keymap.set("n", "<leader>du", function()
				dapui.toggle()
			end, {
				desc = "DAP: Alternar Interfaz Visual (UI)",
			})
		end,
	},
}

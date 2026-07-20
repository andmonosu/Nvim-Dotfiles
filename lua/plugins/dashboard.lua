return {
	"nvimdev/dashboard-nvim",
	event = "VimEnter",
	dependencies = { "nvim-telescope/telescope.nvim" },
	opts = function()
		-- El logo de NeoVim
		local raw_logo = {
			[[ ██╗  ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗]],
			[[ ████╗██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║]],
			[[ ██╔██╗██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║]],
			[[ ██║╚████║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║]],
			[[ ██║ ╚███║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║]],
			[[ ╚═╝  ╚══╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
		}

		-- FUNCIÓN UNIFICADA: Maneja Tmux, el CD de Neovim y abre Telescope
		_G._dashboard_select_project = function(path)
			local expanded_path = vim.fn.expand(path)

			if os.getenv("TMUX") then
				local handle_current = io.popen("tmux display-message -p '#{pane_id}'")
				local current_pane = handle_current:read("*a"):gsub("%s+", "")
				handle_current:close()

				local handle_all = io.popen("tmux list-panes -F '#{pane_id}'")
				for pane in handle_all:lines() do
					pane = pane:gsub("%s+", "")
					if pane ~= current_pane then
						os.execute(string.format("tmux kill-pane -t %s", pane))
					end
				end
				handle_all:close()

				-- CORRECCIÓN: Añadimos '--port 50000' para que levante el servidor expuesto
				local split_cmd =
					string.format("tmux split-window -h -p 30 -c '%s' 'opencode --port 50000'", expanded_path)
				os.execute(split_cmd)

				os.execute(string.format("tmux select-pane -t %s", current_pane))
			end

			vim.cmd(string.format("cd %s", vim.fn.fnameescape(expanded_path)))
			require("telescope.builtin").find_files()
		end

		-- 1. BOTONES DINÁMICOS DE PROYECTOS
		local center_content = {}
		local project_buttons_count = 0
		local project_dir = vim.fn.expand("~/Projects")

		if vim.fn.isdirectory(project_dir) == 1 then
			local paths = vim.fn.globpath(project_dir, "*/", false, true)
			if #paths > 0 then
				for i = 1, math.min(5, #paths) do
					local path = paths[i]:gsub("/$", "")
					local folder_name = vim.fn.fnamemodify(path, ":t")

					table.insert(center_content, {
						action = string.format("lua _G._dashboard_select_project('%s')", path),
						desc = folder_name,
						icon = " ",
						key = tostring(i),
					})
					project_buttons_count = project_buttons_count + 1
				end
			end
		end

		-- Si no hay proyectos, ponemos un aviso estático
		if project_buttons_count == 0 then
			table.insert(
				center_content,
				{ action = "echo", desc = "No projects found in ~/Projects", icon = "󰏌 ", key = "p" }
			)
			project_buttons_count = 1
		end

		-- 2. BOTONES DE MAIN MENU
		table.insert(center_content, { action = "Telescope oldfiles", desc = "Recent Files", icon = " ", key = "r" })
		table.insert(
			center_content,
			{ action = "lua require('persistence').load()", desc = "Restore Session", icon = "󰦛 ", key = "s" }
		)
		table.insert(center_content, { action = "Telescope find_files", desc = "Find File", icon = " ", key = "f" })
		table.insert(center_content, { action = "ene | startinsert", desc = "New File", icon = " ", key = "n" })
		table.insert(center_content, { action = "Telescope live_grep", desc = "Find Text", icon = " ", key = "g" })

		-- Botones especiales actualizados con la misma lógica de Tmux
		table.insert(center_content, {
			action = "lua _G._dashboard_select_project('~/dotfiles')",
			desc = "Dotfiles (~/dotfiles)",
			icon = " ",
			key = "d",
		})
		table.insert(center_content, {
			action = "lua _G._dashboard_select_project('~/.config/nvim')",
			desc = "Nvim Config",
			icon = " ",
			key = "c",
		})

		table.insert(center_content, { action = "Lazy", desc = "Lazy Package Manager", icon = "󰒲 ", key = "l" })
		table.insert(center_content, { action = "qa!", desc = "Quit Neovim", icon = " ", key = "q" })

		-- 3. FORMATEAR ESPACIADOS DE BOTONES
		for _, button in ipairs(center_content) do
			button.desc = string.rep(" ", 4) .. button.desc .. string.rep(" ", 32 - #button.desc)
			button.key_format = " %s"
			button.icon_hl = "DashboardMelangeIcon"
			button.desc_hl = "DashboardMelangeDesc"
			button.key_hl = "DashboardMelangeKey"
		end

		-- 4. CONSTRUCCIÓN DEL HEADER
		local total_lines = vim.o.lines
		local total_content_height = #raw_logo + (#center_content * 2) + 12
		local top_padding = math.max(0, math.floor((total_lines - total_content_height) / 2) - 1)

		local header_content = {}
		for _ = 1, top_padding do
			table.insert(header_content, "")
		end
		for _, line in ipairs(raw_logo) do
			table.insert(header_content, line)
		end

		table.insert(header_content, "")
		table.insert(header_content, "")

		_G._dashboard_header_height = #header_content

		local opts = {
			theme = "doom",
			hide = {
				statusline = true,
				tabline = true,
				winbar = true,
			},
			config = {
				header = header_content,
				header_pad = 2,
				center_pad = 1,
				center = center_content,
				footer = function()
					local stats = require("lazy").stats()
					local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
					return {
						"⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. " ms",
					}
				end,
			},
		}

		return opts
	end,
	config = function(_, opts)
		if vim.filetype and not vim.filetype.ft_to_lang then
			vim.filetype.ft_to_lang = function(ft)
				local query = require("nvim-treesitter.query")
				return query.get_supported_lang(ft) or ft
			end
		end

		-- Colores Melange
		vim.api.nvim_set_hl(0, "DashboardHeader", { fg = "#D47766", bold = true })
		vim.api.nvim_set_hl(0, "DashboardSectionTitle", { fg = "#EB9F71", bold = true })
		vim.api.nvim_set_hl(0, "DashboardMelangeIcon", { fg = "#EB9F71" })
		vim.api.nvim_set_hl(0, "DashboardMelangeDesc", { fg = "#DFD5C6" })
		vim.api.nvim_set_hl(0, "DashboardMelangeKey", { fg = "#EBC06D", bold = true })
		vim.api.nvim_set_hl(0, "DashboardFooter", { fg = "#786D5F", italic = true })

		require("dashboard").setup(opts)

		-- 5. ALINEADOR DINÁMICO RESPECTO A LOS SHORTCUTS
		vim.api.nvim_create_autocmd("User", {
			pattern = "DashboardLoaded",
			callback = function()
				local bufnr = vim.api.nvim_get_current_buf()
				if vim.bo[bufnr].filetype ~= "dashboard" then
					return
				end

				vim.bo[bufnr].modifiable = true

				local header_len = _G._dashboard_header_height or 0
				local project_line_idx = header_len + 1

				local project_line_text = vim.api.nvim_buf_get_lines(
					bufnr,
					project_line_idx - 1,
					project_line_idx,
					false
				)[1] or ""
				local indentation = project_line_text:match("^(%s*)") or "            "

				local t_projects = indentation .. "────── PROJECTS ──────"
				local t_main = indentation .. "───── MAIN MENU ─────"

				if header_len > 0 then
					vim.api.nvim_buf_set_lines(bufnr, header_len - 1, header_len, false, { t_projects })
					vim.api.nvim_buf_add_highlight(bufnr, -1, "DashboardSectionTitle", header_len - 1, 0, -1)
				end

				old_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
				local target_line_idx = nil

				for idx, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
					if line:match("%s+%[r%]") or line:match("%s+Recent Files") then
						target_line_idx = idx - 1
						break
					end
				end

				if target_line_idx then
					vim.api.nvim_buf_set_lines(bufnr, target_line_idx, target_line_idx, false, { "", t_main })
					vim.api.nvim_buf_add_highlight(bufnr, -1, "DashboardSectionTitle", target_line_idx + 1, 0, -1)
				end

				vim.bo[bufnr].modified = false
				vim.bo[bufnr].modifiable = false
			end,
		})

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "dashboard",
			callback = function()
				vim.opt_local.bufhidden = "wipe"
				vim.opt_local.buflisted = false
			end,
		})
	end,
}

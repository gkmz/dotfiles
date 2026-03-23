local M = {}

local group = vim.api.nvim_create_augroup("dotfiles_image_preview", { clear = true })
local state_by_buf = {}

local image_extensions = {
	png = true,
	jpg = true,
	jpeg = true,
	gif = true,
	webp = true,
	bmp = true,
	svg = true,
	tif = true,
	tiff = true,
	avif = true,
}

local function is_buf_valid(buf)
	return buf and vim.api.nvim_buf_is_valid(buf)
end

local function is_win_valid(win)
	return win and vim.api.nvim_win_is_valid(win)
end

local function notify(message, level)
	vim.schedule(function()
		vim.notify(message, level or vim.log.levels.INFO)
	end)
end

local function clear_image_nvim(buf)
	local state = state_by_buf[buf]
	if not state or not state.image_nvim then
		return
	end
	pcall(function()
		state.image_nvim:clear()
	end)
	state.image_nvim = nil
end

function M.is_supported(path)
	if type(path) ~= "string" or path == "" then
		return false
	end
	local ext = vim.fn.fnamemodify(path, ":e"):lower()
	return image_extensions[ext] == true
end

local function build_render_command(path, width, height)
	return {
		"chafa",
		"--animate=off",
		"--format=symbols",
		"--symbols=vhalf",
		"--colors=full",
		"--optimize=9",
		"--scale=1.0",
		("--size=%dx%d"):format(width, height),
		path,
	}
end

local function get_state(buf)
	if not is_buf_valid(buf) then
		return nil
	end
	return state_by_buf[buf]
end

local function set_state(buf, state)
	if is_buf_valid(buf) then
		state_by_buf[buf] = state
	end
end

local function ensure_terminal_channel(buf, state)
	if state.chan then
		return state.chan
	end
	local chan = vim.api.nvim_open_term(buf, {})
	state.chan = chan
	set_state(buf, state)
	return chan
end

local function render_with_image_nvim(buf, win, state)
	local ok, image = pcall(require, "image")
	if not ok then
		return false
	end

	clear_image_nvim(buf)

	local ok_from_file, image_obj = pcall(image.from_file, state.path, {
		window = win,
		buffer = buf,
		inline = false,
		with_virtual_padding = true,
	})
	if not ok_from_file or not image_obj then
		return false
	end

	local ok_render = pcall(function()
		image_obj:render()
	end)
	if not ok_render then
		pcall(function()
			image_obj:clear()
		end)
		return false
	end

	state.image_nvim = image_obj
	set_state(buf, state)
	return true
end

local function render_with_chafa(buf, win, state)
	if vim.fn.executable("chafa") ~= 1 then
		return false
	end

	clear_image_nvim(buf)

	local chan = ensure_terminal_channel(buf, state)
	if not chan then
		return false
	end

	local width = math.max(vim.api.nvim_win_get_width(win), 20)
	local height = math.max(vim.api.nvim_win_get_height(win) - 1, 5)

	state.request_id = (state.request_id or 0) + 1
	set_state(buf, state)

	local current_request = state.request_id
	local command = build_render_command(state.path, width, height)

	vim.system(command, { text = false }, function(result)
		vim.schedule(function()
			if not is_buf_valid(buf) then
				return
			end

			local latest = get_state(buf)
			if not latest or latest.request_id ~= current_request or latest.path ~= state.path then
				return
			end

			local current_chan = latest.chan
			if not current_chan then
				return
			end

			local output = result.stdout or ""
			if result.code ~= 0 or output == "" then
				output = ("Failed to render image with chafa\n\n%s"):format(result.stderr or "")
			end

			vim.api.nvim_chan_send(current_chan, "\27[2J\27[H" .. output)
		end)
	end)
	return true
end

local function render(buf, win)
	if not is_buf_valid(buf) or not is_win_valid(win) then
		return
	end

	local state = get_state(buf)
	if not state then
		return
	end

	if render_with_image_nvim(buf, win, state) then
		return
	end

	if render_with_chafa(buf, win, state) then
		return
	end

	notify("image preview requires `image.nvim` or `chafa`", vim.log.levels.WARN)
end

local function setup_buffer(buf, path)
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].swapfile = false
	vim.bo[buf].filetype = "imagepreview"
	vim.bo[buf].modifiable = true
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "Rendering image preview..." })
	vim.bo[buf].modifiable = false

	vim.keymap.set("n", "q", "<cmd>tabclose<cr>", { buffer = buf, silent = true, desc = "Close image preview" })
	vim.keymap.set("n", "r", function()
		render(buf, vim.api.nvim_get_current_win())
	end, { buffer = buf, silent = true, desc = "Refresh image preview" })
	vim.keymap.set("n", "<esc>", "<cmd>tabclose<cr>", { buffer = buf, silent = true, desc = "Close image preview" })

	set_state(buf, {
		path = path,
		chan = nil,
		image_nvim = nil,
		request_id = 0,
	})
end

function M.open(path)
	path = vim.fn.fnamemodify(path, ":p")
	if vim.fn.filereadable(path) ~= 1 then
		notify(("image preview target does not exist: %s"):format(path), vim.log.levels.ERROR)
		return
	end

	vim.cmd("tabnew")
	local buf = vim.api.nvim_get_current_buf()
	local win = vim.api.nvim_get_current_win()

	setup_buffer(buf, path)

	vim.api.nvim_buf_set_name(buf, ("image://%s"):format(path))

	vim.wo[win].number = false
	vim.wo[win].relativenumber = false
	vim.wo[win].signcolumn = "no"
	vim.wo[win].wrap = false
	vim.wo[win].cursorline = false
	vim.wo[win].foldcolumn = "0"
	vim.wo[win].spell = false
	vim.wo[win].list = false

	render(buf, win)
end

vim.api.nvim_create_autocmd({ "BufWinEnter", "VimResized" }, {
	group = group,
	callback = function(event)
		local buf = event.buf
		local state = get_state(buf)
		if not state then
			return
		end

		local win = vim.fn.bufwinid(buf)
		if win == -1 then
			return
		end

		render(buf, win)
	end,
})

vim.api.nvim_create_autocmd("BufWipeout", {
	group = group,
	callback = function(event)
		clear_image_nvim(event.buf)
		state_by_buf[event.buf] = nil
	end,
})

return M

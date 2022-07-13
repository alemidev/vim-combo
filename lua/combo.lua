--[[

COMBO Counter

]]--

-- Check if already loaded
if vim.g.combo_tracker_already_loaded then
	return
end

vim.g.combo_tracker_already_loaded = true
vim.g.combo_timeout = 1.0 -- seconds

-- Check for a 'combo' folder, make one if missing
local separator = '/'
if vim.fn.has('win32') ~= 0 then
	separator = '\\'
end
local combo_path = vim.fn.stdpath("data") .. separator .. "combo"
local ok, err, code = os.rename(combo_path, combo_path)
if not ok then
	if code == 13 then
		print("[!] could not find or create combo folder")
		print(err)
		return
	else
		vim.fn.mkdir(combo_path, "p")
	end
end

-- Set globals
vim.g.combo_enabled = true
vim.g.combo_counter = 0
vim.g.best_combo = 0
vim.g.best_last_combo = 0
vim.g.combo = ""

vim.g.last_combo = vim.fn.reltimefloat(vim.fn.reltime())

vim.g.combo_file = combo_path .. separator .. 'none'

-- Define necessary functions

local function combo_fmt()
	if not vim.g.combo_enabled then return "" end
	return string.format("%d|%d", vim.g.best_combo, vim.g.combo_counter)
end

local function save_combo()
	if not vim.g.combo_enabled then return end
	if vim.g.combo_counter > vim.g.best_combo then
		vim.fn.writefile({vim.g.combo_counter}, vim.g.combo_file)
		vim.g.best_last_combo = vim.g.best_combo
		vim.g.best_combo = vim.g.combo_counter
	end
end

local function reload_combo_file()
	if not vim.g.combo_enabled then return end
	vim.g.combo_file_type = vim.opt.filetype._value
	if vim.g.combo_file_type then
		vim.g.combo_file = combo_path .. separator .. vim.g.combo_file_type
	end
	vim.g.best_combo = 0
	if vim.fn.filereadable(vim.g.combo_file) ~= 0 then
		local contents = vim.fn.readfile(vim.g.combo_file)
		if contents ~= nil then
			vim.g.best_combo = tonumber(contents[1])
		end
	end
	vim.g.best_last_combo = vim.g.best_combo
	vim.g.combo = combo_fmt()
end

local function update_combo()
	if not vim.g.combo_enabled then return end
	if vim.fn.reltimefloat(vim.fn.reltime(vim.g.last_combo)) > vim.g.combo_timeout then
		save_combo()
		vim.g.combo_counter = 1
	else
		vim.g.combo_counter = vim.g.combo_counter + 1
	end
	vim.g.combo = combo_fmt()
	vim.g.last_combo = vim.fn.reltime()
end

-- Define user-facing functions

function ComboToggle()
	vim.g.combo_enabled = not vim.g.combo_enabled
	vim.g.combo = combo_fmt()
end

function ComboEnable()
	vim.g.combo_enabled = true
	vim.g.combo = combo_fmt()
end

function ComboDisable()
	vim.g.combo_enabled = false
	vim.g.combo = combo_fmt()
end

function ComboCheated()
	vim.g.best_combo = vim.g.best_last_combo
	vim.g.combo_counter = vim.g.best_last_combo
	vim.fn.writefile({vim.g.combo_counter}, vim.g.combo_file)
end

local vim_combo_group = vim.api.nvim_create_augroup("VimComboGroup", {clear=true})
vim.api.nvim_create_autocmd({ "FileType" }, { pattern={"*"}, callback=reload_combo_file, group=vim_combo_group })
vim.api.nvim_create_autocmd({ "TextChangedI", "TextChangedP" }, { callback=update_combo, group=vim_combo_group })
vim.api.nvim_create_autocmd({ "InsertLeave"}, { callback=save_combo, group=vim_combo_group })

local function decrease_bs()
	vim.g.combo_counter = vim.g.combo_counter - 1
	return "<BS>"
end
vim.keymap.set('i', '<BS>', decrease_bs, {expr=true})

local function decrease_del()
	vim.g.combo_counter = vim.g.combo_counter - 1
	return "<DEL>"
end
vim.keymap.set('i', '<DEL>', decrease_del, {expr=true})


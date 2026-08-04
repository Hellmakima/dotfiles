--- @since 25.5.28

--- Returns a list of selected file/dir paths, falling back to the hovered entry.
--- @return string[] paths
--- @return string? err
local get_targets = ya.sync(function(_)
	local selected = cx.active.selected
	if #selected > 0 then
		local paths = {}
		for _, url in pairs(selected) do
			table.insert(paths, tostring(url))
		end
		return paths, nil
	end

	local hovered = cx.active.current.hovered
	if hovered then
		return { tostring(hovered.url) }, nil
	end

	return {}, "No files selected or hovered"
end)

--- Returns the current working directory path.
--- @return string
local get_cwd = ya.sync(function(_)
	return tostring(cx.active.current.cwd)
end)

local M = {}

function M:entry(_)
	-- 1. Collect targets
	local paths, err = get_targets()
	if err or #paths == 0 then
		ya.notify({
			title = "Zip",
			content = err or "No files selected",
			timeout = 4,
			level = "error",
		})
		return
	end

	-- 2. Ask for output name
	local cwd = get_cwd()
	local default_name = #paths == 1
		and (tostring(paths[1]):match("[^\\/]+$") or "archive")
		or "archive"

	local name, event = ya.input({
		title = "Zip name:",
		value = default_name,
		pos = { "center", w = 50 },
	})

	if event ~= 1 or not name or name == "" then
		return
	end

	-- 3. Ensure .zip extension
	if not name:match("%.zip$") then
		name = name .. ".zip"
	end

	-- 4. Build zip command: run via sh so we can cd into cwd first,
	--    then pass paths relative to cwd so the archive has no absolute paths.
	local rel_paths = {}
	local cwd_prefix = cwd:gsub("([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1") .. "/"
	for _, p in ipairs(paths) do
		-- strip cwd/ prefix to get a relative path (handles files in sub-dirs)
		local rel = p:gsub("^" .. cwd_prefix, "")
		table.insert(rel_paths, rel)
	end

	-- sh -c 'cd "$1" && shift && zip -r "$@"' -- <cwd> <name> <rel1> [rel2 ...]
	local sh_args = { "-c", 'cd "$1" && shift && zip -r "$@"', "--", cwd, name }
	for _, rel in ipairs(rel_paths) do
		table.insert(sh_args, rel)
	end

	local output, cmd_err = Command("sh"):arg(sh_args):output()

	-- 5. Report result
	if not output then
		ya.notify({
			title = "Zip",
			content = "Failed to run zip: " .. tostring(cmd_err),
			timeout = 5,
			level = "error",
		})
	elseif not output.status.success then
		ya.notify({
			title = "Zip",
			content = "zip exited with code "
				.. tostring(output.status.code)
				.. (output.stderr ~= "" and (": " .. output.stderr) or ""),
			timeout = 5,
			level = "error",
		})
	else
		ya.notify({
			title = "Zip",
			content = "Created " .. name
				.. " (" .. #paths .. " item" .. (#paths == 1 and "" or "s") .. ")",
			timeout = 3,
			level = "info",
		})
	end
end

return M

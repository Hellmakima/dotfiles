require("relative-motions"):setup({ show_numbers = "relative", show_motion = true, enter_mode = "first" })
-- ~/.config/yazi/init.lua
require("bookmarks"):setup({
	last_directory = { enable = false, persist = false, mode = "dir" },
	persist = "all",
	desc_format = "full",
	file_pick_mode = "hover",
	custom_desc_input = false,
	show_keys = false,
	notify = {
		enable = false,
		timeout = 1,
		message = {
			new = "New bookmark '<key>' -> '<folder>'",
			delete = "Deleted bookmark in '<key>'",
			delete_all = "Deleted all bookmarks",
		},
	},
})

-- git plugin
require("git"):setup({
	-- Order of status signs showing in the linemode
	order = 1500,
})

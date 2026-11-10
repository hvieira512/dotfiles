local harpoon = require("harpoon")

harpoon.setup({})

local keymap = vim.keymap
keymap.set("n", "<leader>h", function()
	harpoon:list():add()
end, { desc = "Add File to Harpoon" })
keymap.set("n", "<leader>H", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Toggle Harpoon Menu" })

for i = 1, 6 do
	keymap.set("n", "<leader>" .. i, function()
		harpoon:list():select(i)
	end, { desc = "Harpoon File " .. i })
end

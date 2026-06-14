-- Line navigation
vim.keymap.set({ "n", "v" }, "H", "^", { desc = "Start of line" })
vim.keymap.set({ "n", "v" }, "L", "$", { desc = "End of line" })

-- Page navigation
vim.keymap.set({ "n", "v" }, "J", "<C-d>", { desc = "Scroll down" })
vim.keymap.set({ "n", "v" }, "K", "<C-u>", { desc = "Scroll up" })

-- Escape insert mode
vim.keymap.set("i", "jk", "<Esc>", { desc = "Escape insert mode" })

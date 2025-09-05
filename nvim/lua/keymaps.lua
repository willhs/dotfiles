-- back, forward jumps (<C-o> back, <C-i> forward) AND add JetBrains-style
vim.keymap.set("n", "<C-h>", "<C-o>", { desc = "Jump back (JetBrains style)" })
vim.keymap.set("n", "<C-l>", "<C-i>", { desc = "Jump forward (JetBrains style)" })

-- find/grep string in project
vim.keymap.set("n", "<leader>g", function() require("telescope.builtin").live_grep() end, { desc = "Grep project" })

-- jump to this config file
vim.keymap.set("n", "<leader>v", ":e $MYVIMRC<CR>", { desc = "Edit init.lua" })

-- LSP keymaps
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
vim.keymap.set("n", "K",  vim.lsp.buf.hover)
vim.keymap.set("n", "gr", function() require("telescope.builtin").lsp_references() end)
vim.keymap.set("n", "gt", function() require("telescope.builtin").lsp_type_definitions() end)
vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { desc = "Rename symbol" })
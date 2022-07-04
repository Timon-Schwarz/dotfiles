---------------
-- variables --
---------------
local options = { noremap = true, silent = true }
local command_options = { cnoremap = true, silent = true }



----------------------
-- global mappings --
----------------------
vim.api.nvim_set_keymap("", "<Space>", "<Nop>", options)
vim.g.mapleader = " "
vim.g.maplocalleader = " "



--------------------------
-- normal mode mappings --
--------------------------
-- better split navigation
vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", options)
vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", options)
vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", options)
vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", options)

-- resize splits with arrows
vim.api.nvim_set_keymap("n", "<C-Up>", ":resize +2<CR>", options)
vim.api.nvim_set_keymap("n", "<C-Down>", ":resize -2<CR>", options)
vim.api.nvim_set_keymap("n", "<C-Left>", ":vertical resize -2<CR>", options)
vim.api.nvim_set_keymap("n", "<C-Right>", ":vertical resize +2<CR>", options)

-- navigate buffers
vim.api.nvim_set_keymap("n", "<S-l>", ":bnext<CR>", options)
vim.api.nvim_set_keymap("n", "<S-h>", ":bprevious<CR>", options)

-- file explorer
vim.api.nvim_set_keymap("n", "<leader>e", ":NvimTreeToggle<CR>", options)

-- move to placeholder
-- no delete command is being used so that the copy register stays unaltered
vim.api.nvim_set_keymap("n", "<leader><leader>", "/<++><CR>ca<", options)



--------------------------
-- insert mode mappings --
--------------------------



--------------------------
-- visual mode mappings --
--------------------------
-- Do not overwirte clipboard when replacing something by pasting
vim.api.nvim_set_keymap("v", "p", '"_dP', options)

-- Stay in indent mode while changing indents
vim.api.nvim_set_keymap("v", "<", "<gv", options)
vim.api.nvim_set_keymap("v", ">", ">gv", options)



-----------------------
-- commands mappings --
----------------------
vim.api.nvim_command("cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!")

-------------
-- options --
-------------
vim.opt.spell.spelllang = { "en_us", "de_at" }  -- specify spell checking languages
vim.opt.backup = false                          -- creates a backup file
vim.opt.clipboard = "unnamedplus"               -- allows neovim to access the system clipboard
vim.opt.cmdheight = 1                           -- space in the neovim command line for displaying messages
vim.opt.completeopt = { "menuone", "noselect" } -- mostly just for cmp
vim.opt.conceallevel = 0                        -- so that `` is visible in markdown files
vim.opt.fileencoding = "utf-8"                  -- the encoding written to a file
vim.opt.hlsearch = true                         -- highlight all matches on previous search pattern
vim.opt.ignorecase = true                       -- ignore case in search patterns
vim.opt.mouse = "a"                             -- allow the mouse to be used in neovim
vim.opt.showmode = false                        -- we don't need to see things like -- INSERT -- anymore
vim.opt.showtabline = 4                         -- always show tabs
vim.opt.smartcase = true                        -- smart case
vim.opt.smartindent = true                      -- make indenting smarter again
vim.opt.splitbelow = true                       -- force all horizontal splits to go below current window
vim.opt.splitright = true                       -- force all vertical splits to go to the right of current window
vim.opt.swapfile = false                        -- creates a swapfile
vim.opt.termguicolors = true                    -- set term gui colors (most terminals support this)
vim.opt.undofile = true                         -- enable persistent undo
vim.opt.updatetime = 300                        -- faster completion (4000ms default)
vim.opt.writebackup = false                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
vim.opt.expandtab = true                        -- convert tabs to spaces
vim.opt.shiftwidth = 4                          -- the number of spaces inserted for each indentation
vim.opt.tabstop = 4                             -- insert 2 spaces for a tab
vim.opt.autoindent = true                       -- automatically indent new lines
vim.opt.cursorline = true                       -- highlight the current line
vim.opt.number = true                           -- set numbered lines
vim.opt.relativenumber = false                  -- set relative numbered lines
vim.opt.signcolumn = "yes"                      -- always show the sign column, otherwise it would shift the text each time
vim.opt.wrap = false                            -- display lines as one long line
vim.opt.scrolloff = 8                           -- starts scrolling 8 lines before the last visible line
vim.opt.sidescrolloff = 8                       -- starts scrollling 8 characters before the last character in line
vim.opt.guifont = "Jetbrains Mono Nerd Font:h11"-- the font used in graphical neovim applications
vim.opt.wildmode = { "longest", "list", "full" }-- makes command auto completion work more intuitivly



----------------------------
-- FileType auto commands --
----------------------------
local file_type_group = vim.api.nvim_create_augroup("file_type_group", { clear = true })

-- disables auto commenting. Must be set via autocmd because some plugins overwrite it
vim.api.nvim_create_autocmd("FileType",
    { pattern = "*",
        command = "setlocal formatoptions-=cro",
        group=file_type_group })



----------------------------
-- VimEnter auto commands --
----------------------------
local vim_enter_group = vim.api.nvim_create_augroup("vim_enter_group", { clear = true })

-- fixes a bug that caused nvim to be sized improperly when started with 'alacritty -e nvim'
--vim.api.nvim_create_autocmd("VimEnter",
--    { pattern = "*",
--        command = "call timer_start(20, { tid -> execute(\":silent exec '!kill -s SIGWINCH $PPID'\")})",
--        group=file_type_group })



-------------------------------
-- BufWritePre auto commands --
-------------------------------
local buf_write_pre_group = vim.api.nvim_create_augroup("buf_write_pre_group", { clear = true })

-- store initial cursor position
vim.api.nvim_create_autocmd("BufWritePre",
    { pattern = "*",
        command = "let initialPosition = getpos(\".\")",
        group=buf_write_pre_group })



-- automatically remove trailing white space from each line
vim.api.nvim_create_autocmd("BufWritePre",
    { pattern = "*",
        command = "silent! %s/\\n\\+\\%$//e",
        group=buf_write_pre_group })

-- automatically add one trailing newline for files with these extensions
local eof_blank_line_exceptions = { "*.c", "*.h", "*.py" }
for i, exception in ipairs(eof_blank_line_exceptions) do
    vim.api.nvim_create_autocmd("BufWritePre",
        { pattern = exception,
            command = "silent! %s/\\%$/\\r/e",
            group=buf_write_pre_group })
end



-- automatically make exactly 3 blank lines if there is more than 1 blank line
vim.api.nvim_create_autocmd("BufWritePre",
    { pattern = "*",
        command = "silent! %s/\\n\\n\\n\\+/\r\r\r\r",
        group=buf_write_pre_group })

-- automatically make exactly 2 blank lines if there is more than 1 blank line for files with these extensions
local multi_blank_line_exceptions = { "*.py" }
for i, exception in ipairs(multi_blank_line_exceptions) do
    vim.api.nvim_create_autocmd("BufWritePre",
        { pattern = exception,
            command = "silent! %s/\\n\\n\\n\\+/\r\r\r",
            group=buf_write_pre_group })
end

-- move the cursor back to it's initial position
vim.api.nvim_create_autocmd("BufWritePre",
    { pattern = exception,
        command = "cal cursor(initialPosition[1], initialPosition[2])",
        group=buf_write_pre_group })

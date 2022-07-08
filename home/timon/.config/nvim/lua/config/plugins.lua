---------------------
-- user experience --
---------------------
-- automatically install packer if not installed already
local install_path = vim.fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = vim.fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    }
    print "Installing packer close and reopen Neovim..."
    vim.cmd [[packadd packer.nvim]]
end

-- automatically reload the plugins after they are changed
local buf_write_post_group = vim.api.nvim_create_augroup("packer_user_config", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", { pattern = "plugins.lua", command = "source <afile> | PackerSync", group = buf_write_post_group})

-- use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- have packer use a popup window
packer.init {
    display = {
        open_fn = function()
            return require("packer.util").float { border = "rounded" }
        end,
    },
}



-------------
-- plugins --
-------------
return packer.startup(function(use)
    -- plugin management
    use "wbthomason/packer.nvim"          -- have packer manage itself

    -- plugin dependencies
    use "nvim-lua/popup.nvim"             -- some plugins require this: an implementation of the Popup API from vim in Neovim
    use "nvim-lua/plenary.nvim"           -- some plugins require this: generally useful lua functions

    -- cholorschemes
    use "dracula/vim"                     -- allows to use the dracula color shema

    -- UI addons
    use "vim-airline/vim-airline"         -- adds some UI elements
    use "vim-airline/vim-airline-themes"  -- adds theming for the vim-airline plugin
    use "kyazdani42/nvim-web-devicons"    -- adds icons
    
    -- file explorer
    use "kyazdani42/nvim-tree.lua"        -- file explorer

    -- completion
    use "hrsh7th/nvim-cmp"                -- The completion plugin
    use "hrsh7th/cmp-buffer"              -- buffer completions
    use "hrsh7th/cmp-path"                -- path completions
    use "hrsh7th/cmp-cmdline"             -- cmdline completions
    use "saadparwaiz1/cmp_luasnip"        -- snippet completions

    -- snippets
    use "L3MON4D3/LuaSnip"                -- snippet engine
    use "rafamadriz/friendly-snippets"    -- a bunch of snippets to use

    -- LaTeX
    use {
        "lervag/vimtex",                  -- plugin for LaTeX writing
        ft = { "tex" }                    -- load plugin only when opening .tex file
    }

    -- automatically set up your configuration after cloning packer.nvim
    -- put this at the end after all plugins
    if PACKER_BOOTSTRAP then
      require("packer").sync()
    end
end)

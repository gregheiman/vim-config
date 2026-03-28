-- =============================================================================
--  init.lua — converted from .vimrc
--  Plugin manager: lazy.nvim
-- =============================================================================

-- =============================================================================
-- SECTION 1: Bootstrap lazy.nvim
-- =============================================================================
-- lazy.nvim installs itself to stdpath("data")/lazy/lazy.nvim the first time
-- you open Neovim. Nothing else to install manually.

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- =============================================================================
-- SECTION 2: Leader key (must be set BEFORE lazy.nvim loads plugins)
-- =============================================================================
vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"

-- =============================================================================
-- SECTION 3: Plugins via lazy.nvim
-- =============================================================================
require("lazy").setup({

    -- -------------------------------------------------------------------------
    -- Tpope essentials (kept from original config)
    -- -------------------------------------------------------------------------
    { "tpope/vim-fugitive" },   -- Git wrapper
    { "tpope/vim-surround" },   -- Easy surrounding of current selection
    { "tpope/vim-commentary" }, -- Easy commenting of lines

    -- -------------------------------------------------------------------------
    -- Colorscheme
    -- -------------------------------------------------------------------------
    {
        "xero/sourcerer.vim",
        lazy = false,    -- Load at startup
        priority = 1000, -- Load before everything else
        config = function()
            vim.cmd("colorscheme sourcerer")
            vim.api.nvim_set_hl(0, "SignColumn", { link = "LineNr" })
            vim.api.nvim_set_hl(0, "StatusLine", { link = "LineNr" })
            -- vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "reverse" })
            vim.api.nvim_set_hl(0, "TabLine", { link = "LineNr" })
        end,
    },

    -- -------------------------------------------------------------------------
    -- Auto-pairs (replaces pear-tree)
    -- -------------------------------------------------------------------------
    {
        "echasnovski/mini.pairs",
        version = "*",
        config = function()
            require("mini.pairs").setup()
        end,
    },

    -- -------------------------------------------------------------------------
    -- Fuzzy finding (replaces fzf + fzf.vim)
    -- -------------------------------------------------------------------------
    {
        "echasnovski/mini.pick",
        version = "*",
        config = function()
            require('mini.pick').setup({ window = { config = { width = vim.o.columns } } })
            vim.keymap.set("n", "<leader>f", ":Pick grep<CR>", { noremap=true, silent=true, desc = "Pick: Grep"})
            vim.api.nvim_create_user_command("Files", function()
                vim.cmd("Pick files")
            end, {desc = "Open files search"})
        end,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            -- Shared keymaps applied whenever any LSP attaches to a buffer.
            -- LspAttach replaces the old on_attach pattern.
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
                callback = function(event)
                    local opts = { buffer = event.buf, silent = true }

                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client:supports_method("textDocument/completion") then
                        vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
                        vim.bo[event.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
                    end

                    vim.keymap.set("n", "gd",         vim.lsp.buf.definition,     vim.tbl_extend("force", opts, { desc = "LSP: go to definition" }))
                    vim.keymap.set("n", "<C-]>",      vim.lsp.buf.definition,     vim.tbl_extend("force", opts, { desc = "LSP: go to definition" }))
                    vim.keymap.set("n", "K",          vim.lsp.buf.hover,          vim.tbl_extend("force", opts, { desc = "LSP: hover docs" }))
                    vim.keymap.set("n", "gi",         vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "LSP: go to implementation" }))
                    vim.keymap.set("n", "gr",         vim.lsp.buf.references,     vim.tbl_extend("force", opts, { desc = "LSP: go to references" }))
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,         vim.tbl_extend("force", opts, { desc = "LSP: rename symbol" }))
                    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,    vim.tbl_extend("force", opts, { desc = "LSP: code action" }))
                    vim.keymap.set("n", "]q", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
                    vim.keymap.set("n", "[q", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Prev diagnostic" }))
                    vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format)
                end,
            })

            vim.lsp.config("pylsp",         { capabilities = capabilities })
            vim.lsp.config("rust_analyzer", { capabilities = capabilities })
            vim.lsp.config("ts_ls",         { capabilities = capabilities })
            vim.lsp.config("clangd", {
                capabilities = capabilities,
                -- background indexing, clang-tidy diagnostics, and IWYU-style includes
                cmd      = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu" },
                filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
            })

            -- Enable the servers — vim.lsp.enable() replaces lspconfig's autostart
            vim.lsp.enable({ "pylsp", "rust_analyzer", "ts_ls", "clangd" })
            -- Diagnostic display config
            vim.diagnostic.config({
                virtual_text     = true,
                signs            = true,
                underline        = true,
                update_in_insert = false,
                severity_sort    = true,
            })

        end,
    },
    -- -------------------------------------------------------------------------
    -- LSP: Mason (installer only) — server config via vim.lsp.config (nvim 0.11+)
    -- -------------------------------------------------------------------------
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
        },
        config = function()
            -- mason-lspconfig: auto-install these servers via Mason
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "pylsp",         -- Python
                    "rust_analyzer", -- Rust
                    "ts_ls",         -- TypeScript / JavaScript
                    "clangd",        -- C / C++
                },
                automatic_installation = true,
            })
        end,
    },
    -- -------------------------------------------------------------------------
    -- Project: Automatically change directory to project root
    -- -------------------------------------------------------------------------
    {
        "DrKJeff16/project.nvim",
        config = function()
            require("project").setup()
        end
    }
}, {
    -- lazy.nvim options
    ui = {
        border = "rounded",
    },
})

-- =============================================================================
-- SECTION 4: Core Options (ported from set ... lines)
-- =============================================================================
local opt = vim.opt

opt.compatible    = false          -- nocompatible
opt.syntax        = "on"
opt.mouse         = "a"
opt.wrap          = false          -- nowrap
opt.autowriteall  = true
opt.encoding      = "utf-8"
opt.fileformat    = "unix"
opt.fileformats   = { "unix", "dos" }
opt.path:remove("/usr/include")
opt.wildignore:append("**/.git/**")
opt.showmode      = false          -- noshowmode
opt.backspace     = { "indent", "eol", "start" }
opt.tags          = { "./tags", "tags" }
opt.shortmess:append("c")
opt.completeopt   = { "menuone", "noselect" }
opt.pumheight     = 10
opt.number        = true
opt.tabstop       = 4
opt.shiftwidth    = 4
opt.smarttab      = true
opt.expandtab     = true
opt.incsearch     = true
opt.hlsearch      = false          -- nohlsearch
opt.ignorecase    = true
opt.smartcase     = true
opt.splitright    = true
opt.splitbelow    = true
opt.laststatus    = 2
opt.cursorline    = true
opt.spell         = true
opt.spelllang     = { "en_us" }
opt.swapfile      = false          -- noswapfile
opt.undofile      = true
opt.backup        = true
opt.undodir       = vim.fn.expand("~/.vim-undo//")
opt.backupdir     = vim.fn.expand("~/.vim-backup//")
opt.sessionoptions = { "curdir", "folds", "globals", "options", "tabpages", "unix", "slash" }
opt.colorcolumn   = "80"
opt.background    = "dark"
opt.wildmenu      = true
opt.termguicolors = true
opt.clipboard:append("unnamedplus")

-- Ensure undo/backup dirs exist
vim.fn.mkdir(vim.fn.expand("~/.vim-undo"),   "p")
vim.fn.mkdir(vim.fn.expand("~/.vim-backup"), "p")

-- Use ripgrep if available
if vim.fn.executable("rg") == 1 then
    opt.grepprg    = "rg --vimgrep"
    opt.grepformat = "%f:%l:%c:%m"
end

-- GUI font
if vim.fn.has("gui_running") == 1 then
    opt.guifont = "JetBrains Mono Regular:h11"
end

-- Global tex flavor
vim.g.tex_flavor = "latex"

-- =============================================================================
-- SECTION 5: Netrw configuration
-- =============================================================================
vim.g.netrw_banner  = 0
vim.g.netrw_keepdir = 0

-- =============================================================================
-- SECTION 6: Statusline (ported from custom vimscript statusline)
-- =============================================================================
-- Mode display table
local mode_map = {
    n       = "NORMAL",
    v       = "VISUAL",
    V       = "V·LINE",
    ["\22"] = "V·BLOCK", -- <C-V>
    i       = "INSERT",
    R       = "R",
    Rv      = "V·REPLACE",
    c       = "COMMAND",
    r       = "REPLACE",
    t       = "TERMINAL",
}

local function get_mode()
    return (mode_map[vim.fn.mode()] or vim.fn.mode()):upper()
end

local function get_git_branch()
    local branch = vim.fn.FugitiveHead()
    return branch ~= "" and branch or ""
end

-- Build the statusline string each time it is evaluated
function _G.build_statusline()
    local parts = {
        " " .. get_mode() .. " | ",
        get_git_branch() ~= "" and (get_git_branch() .. " | ") or "",
        "%t | ",       -- filename (tail)
        "%(%m%r%h%w%)", -- modified / ro / help / preview flags
        "%=",           -- right-align the rest
        "%Y",           -- filetype
        " | %{toupper(&ff)}",   -- line endings
        " | %{toupper(&enc)}",  -- encoding
        " | %l/%L ",    -- current line / total lines
    }
    return table.concat(parts)
end

vim.opt.statusline = "%!v:lua.build_statusline()"

-- =============================================================================
-- SECTION 7: Autocommands
-- =============================================================================
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd


-- Auto-save session on exit if Session.vim exists
local save_session_if_exists_upon_exit_group = augroup("SaveSessionIfExistsUponExit", { clear = true })
autocmd("VimLeavePre", {
    group = save_session_if_exists_upon_exit_group,
    callback = function()
        -- Port of functions#UpdateSessionOnExit
        -- Saves Session.vim in the current directory if one already exists
        local session_file = vim.fn.getcwd() .. "/Session.vim"
        if vim.fn.filereadable(session_file) == 1 then
            vim.cmd("mksession! " .. session_file)
        end
    end,
})

-- Create an augroup for quickfix related autocmds
local quickfix_group = augroup("quickfix", { clear = true })

-- Open the quickfix window for non-location list commands (e.g., :grep, :make)
autocmd("QuickFixCmdPost", {
  group = quickfix_group,
  pattern = { "[^l]*" },
  callback = function()
    vim.cmd("cwindow")
  end,
})

-- Open the location window for location list commands (e.g., :lgrep, :lmake)
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  group = quickfix_group,
  pattern = { "l*" },
  callback = function()
    vim.cmd("lwindow")
  end,
})

-- Close quickfix window with 'q'
autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.keymap.set("n", "q", "<cmd>cclose<CR>", { buffer = true, silent = true, desc = "Close quickfix" })
  end,
})

-- Close netrw window with 'q'
autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    vim.keymap.set("n", "q", "<cmd>bd<CR>", { buffer = true, silent = true, desc = "Close netrw" })
  end,
})

-- =============================================================================
-- SECTION 8: Keymaps
-- =============================================================================
local map = vim.keymap.set
-- Disable Ex mode accidentally
map("n", "Q", "<Nop>")

-- Keep visual selection after indent
map("v", ">", ">gv")
map("v", "<", "<gv")

-- Buffer navigation (mirrors ]b [b etc.)
map("n", "]b",        ":bn<CR>",     { silent = true, desc = "Next buffer" })
map("n", "[b",        ":bp<CR>",     { silent = true, desc = "Prev buffer" })
map("n", "[B",        ":bfirst<CR>", { silent = true, desc = "First buffer" })
map("n", "]B",        ":blast<CR>",  { silent = true, desc = "Last buffer" })
map("n", "<leader>bd", ":bd<CR>",    { silent = true, desc = "Delete buffer" })
map("n", "<leader>bl", ":buffers<CR>", { desc = "List buffers" })

-- Search for visually selected text
map("v", "//", [[y/\V<C-R>=escape(@",'/\')<CR><CR>]], { desc = "Search selection" })

-- Toggle Netrw
map("n", "<leader>d", ":Explore<CR>")
vim.api.nvim_create_user_command("Dired", function()
	vim.cmd("Explore")
end, { desc = "Open Netrw"})

-- Term command: open terminal split in current file's directory
vim.api.nvim_create_user_command("Term", function()
    local dir = vim.fn.expand("%:p:h")
    vim.cmd("sp")
    vim.cmd("term")
    vim.cmd("cd " .. dir)
end, { nargs = 0, bar = true, desc = "Open terminal in current dir" })

-- =============================================================================
-- SECTION 8: Omnicomplete — auto-open + Tab/S-Tab cycling
-- =============================================================================
-- Trigger omnicomplete automatically after a short delay when in insert mode.
-- Uses a simple CursorHoldI autocmd so no extra plugin is needed.
-- The omnifunc is set per-buffer in LspAttach (Section 8) when an LSP attaches.
 
vim.opt.completeopt = {"noselect", "menuone", "noinsert"}
vim.opt.updatetime = 300  -- ms of inactivity before CursorHoldI fires
 
local omni_augroup = vim.api.nvim_create_augroup("OmniAuto", { clear = true })
vim.api.nvim_create_autocmd("CursorHoldI", {
    group    = omni_augroup,
    callback = function()
        -- Only trigger if there's a word character before the cursor
        -- and the popup menu is not already visible
        local col = vim.fn.col(".") - 1
        local line = vim.fn.getline(".")
        local char_before = col > 0 and line:sub(col, col) or ""
        if char_before:match("[%w_%.%-]") and vim.fn.pumvisible() == 0 then
            -- feedkeys mimics the user pressing <C-x><C-o>
            vim.api.nvim_feedkeys(
                vim.api.nvim_replace_termcodes("<C-x><C-o>", true, false, true),
                "n",
                false
            )
        end
    end,
})
 
-- Tab / Shift-Tab to cycle through the popup menu.
-- If the menu is not visible, Tab inserts a literal tab (respecting expandtab).
vim.keymap.set("i", "<Tab>", function()
    if vim.fn.pumvisible() == 1 then
        return vim.api.nvim_replace_termcodes("<C-n>", true, false, true)
    else
        return vim.api.nvim_replace_termcodes("<Tab>", true, false, true)
    end
end, { expr = true, silent = true, desc = "Omni: next item or Tab" })
 
vim.keymap.set("i", "<S-Tab>", function()
    if vim.fn.pumvisible() == 1 then
        return vim.api.nvim_replace_termcodes("<C-p>", true, false, true)
    else
        return vim.api.nvim_replace_termcodes("<S-Tab>", true, false, true)
    end
end, { expr = true, silent = true, desc = "Omni: prev item or S-Tab" })
 
-- Enter confirms the selected item; if nothing is selected, insert a newline.
vim.keymap.set("i", "<CR>", function()
    if vim.fn.pumvisible() == 1 then
        return vim.api.nvim_replace_termcodes("<C-y>", true, false, true)
    else
        return vim.api.nvim_replace_termcodes("<CR>", true, false, true)
    end
end, { expr = true, silent = true, desc = "Omni: confirm or CR" })

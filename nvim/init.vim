" Set Neovim to load .vimrc
if has('win64') || has('win32')
	set runtimepath^=C:/Users/heimangreg/vimfiles runtimepath+=C:/Users/heimangreg/vimfiles/after
else
	set runtimepath^=~/.vim runtimepath+=~/.vim/after
endif
let &packpath = &runtimepath
if has('win64') || has('win32')
	source C:/Users/heimangreg/vimfiles/.vimrc
else
	source ~/.vim/.vimrc
endif

" Neovim specific packages and package configuration
lua << EOF
-- Install packer.nvim Neovim package manager
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.api.nvim_command 'packadd packer.nvim'
end
-- Packer packages
require('packer').startup(function()
    use 'wbthomason/packer.nvim' -- Packer package manager
    use 'neovim/nvim-lspconfig' -- Default configs for easy LSP setup
    use 'kabouzeid/nvim-lspinstall' -- Easy install of LSP
    use { 
      'nvim-telescope/telescope.nvim', -- Fuzzy finder
      requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
    }
end)

-- pear-tree borks telescope's <CR> imap and other stuff
vim.g.pear_tree_ft_disabled = {'TelescopePrompt'}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
  -- Set up mucomplete so that the omnicomplete doesn't get overrun by tags or other completion
  vim.g['mucomplete#chains'] = {
      java = {'path','omni'},
  }
  -- Mappings.
  local opts = { noremap=true, silent=true }
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end

-- config that activates keymaps and enables snippet support
local function make_config()
  return {
    -- map buffer local keybindings when the language server attaches
    on_attach = on_attach,
  }
end

-- Automatically setup LSP servers
local function setup_servers()
  require'lspinstall'.setup()

  local servers = require'lspinstall'.installed_servers()
  
  for _, server in pairs(servers) do
    local config = make_config()
    require'lspconfig'[server].setup(config)
  end
end

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require('lspinstall').post_install_hook = function ()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end

setup_servers()
EOF

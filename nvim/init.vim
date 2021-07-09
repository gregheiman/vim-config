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

" Install packer.nvim Neovim package manager
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

" Neovim specific packages and package configuration
lua << EOF
require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    use 'neovim/nvim-lspconfig'
    use 'kabouzeid/nvim-lspinstall'
end)

require('lspinstall').setup()

-- Automatically install LSP servers
local function setup_servers()
  require('lspinstall').setup()
  local servers = require('lspinstall').installed_servers()
  for _, server in pairs(servers) do
    require('lspconfig')jdtls.setup{}
  end
end

setup_servers()

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require('lspinstall').post_install_hook = function ()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end
EOF
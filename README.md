<p align="center"><img src="https://cdn.iconscout.com/icon/free/png-256/vim-283379.png" width="23%"/></p>
<h1 align="center">Vim-Config</h1>

My personal Vim configuration for Linux, Windows, and MacOS. Works with both Vim 8.1+ and Neovim.
Currently I use Neovim mainly, as such I don't test this configuration on mainline Vim very
often. However, I do not use any Neovim only plugins and the Neovim only configuration always
has a check before it is ran so this configuration should work on mainline Vim 8.1+ without 
much issue.

## Table of Contents
- [Installation for Windows](#installation-for-windows)
- [Installation for MacOS](#installation-for-macos)
- [Installation for Linux](#installation-for-linux)

<a name="installation-for-windows"
### Installation for Windows

1. Install Vim from [here](https://github.com/vim/vim-win32-installer/releases) or through [Chocolatey](https://chocolatey.org/) using the following command:
```
choco install vim
```
2. Clone this repository onto your system
3. Create symlinks for the following files
  * File link command:
    ```
    mklink Link Target
    ```
  * Directory link command:
    ```
    mklink /D Link Target
    ```

    * .vimrc -- your main Vim folder (For chocolatey C:/tools/vim)
    * /after/ directory -> your vimfiles folder
    * /autoload/ directory -> your vimfiles folder
    * /skeletons/ directory -> your vimfiles folder
    * /compiler/ directory -> your vimfiles folder
4. Start Vim.
    * Vim-Plug shouldn't have to be installed (It's in the /autoload/ directory). 
    But if not install [Vim-Plug](https://github.com/junegunn/vim-plug) yourself (follow the instructions on the page). 
    Then run :PlugInstall upon launching Vim for the first time.
5. Restart Vim.

<a name="installation-for-macos"/>
### Installation for MacOS

1. Install MacVim from [here](https://github.com/macvim-dev/macvim/releases/tag/snapshot-161).
2. Clone this repository into your home folder.
3. Create symlinks for the following files
  * Symlink command:
    ```
    ln -s Link Target
    ```

    * .vimrc -- your main Vim folder (~/.vim)
    * /after/ directory -> your .vim folder
    * /autoload/ directory -> your .vim folder
    * /skeletons/ directory -> your .vim folder
    * /compiler/ directory -> your .vim folder
4. Start MacVim.
5. Start Vim.
    * Vim-Plug shouldn't have to be installed (It's in the /autoload/ directory). 
    But if not install [Vim-Plug](https://github.com/junegunn/vim-plug) yourself (follow the instructions on the page). 
    Then run :PlugInstall upon launching Vim for the first time.
6. Restart MacVim.

<a name="installation-for-linux"/>
### Installation for Linux

1. Install Vim through your package manager.
2. Clone this repository into your home folder.
3. Create symlinks for the following files
  * Symlink command:
    ```
    ln -s Link Target
    ```

    * .vimrc -- your main Vim folder (~/.vim)
    * /after/ directory -> your .vim folder
    * /autoload/ directory -> your .vim folder
    * /skeletons/ directory -> your .vim folder
    * /compiler/ directory -> your .vim folder
4. Start Vim.
5. Start Vim.
    * Vim-Plug shouldn't have to be installed (It's in the /autoload/ directory). 
    But if not install [Vim-Plug](https://github.com/junegunn/vim-plug) yourself (follow the instructions on the page). 
    Then run :PlugInstall upon launching Vim for the first time.
6. Restart Vim.

<a name="dependencies"/>
### Dependencies

**Required Dependencies:**

* Git (Needed in order to clone and maintain .vimrc)

**Optional Dependencies:**

* Universal-Ctags or Exuberent-Ctags (Tagging files)
* Ripgrep (Faster grepping)

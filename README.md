# Vim-Config

My personal Vim configuration for Linux and Windows (MacOS should be supported, but untested).
Works with both Vim 8.1+ and Neovim.

## Installation for Windows

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
4. Start Vim.
    * Vim-Plug shouldn't have to be installed (It's in the /autoload/ directory). 
    But if not install [Vim-Plug](https://github.com/junegunn/vim-plug) yourself (follow the instructions on the page). 
    Then run :PlugInstall upon launching Vim for the first time.
5. Restart Vim.

## Installation for MacOS

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
4. Start MacVim.
5. Start Vim.
    * Vim-Plug shouldn't have to be installed (It's in the /autoload/ directory). 
    But if not install [Vim-Plug](https://github.com/junegunn/vim-plug) yourself (follow the instructions on the page). 
    Then run :PlugInstall upon launching Vim for the first time.
6. Restart MacVim.

## Installation for Linux

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
4. Start Vim.
5. Start Vim.
    * Vim-Plug shouldn't have to be installed (It's in the /autoload/ directory). 
    But if not install [Vim-Plug](https://github.com/junegunn/vim-plug) yourself (follow the instructions on the page). 
    Then run :PlugInstall upon launching Vim for the first time.
6. Restart Vim.

## Dependencies
Good development tools to have.

**Tools include:**

* Git (Needed in order to clone and maintain .vimrc)

**Optional Dependencies:**

* Universal-Ctags or Exuberent-Ctags (Tagging files)
* Java JDK (Compile and run Java files)
* LLVM (Includes Clang for compiling C files)
* MinGW-W64 or MinGW (Windows port of GCC for compiling C files)
* NPM and Yarn (Helpful for web development)
* ESLint (JS Linter)
* TexLive (Needed for working with LaTeX files)
* Rubber or Latexmk (Compiles Tex files)
* Various LSP servers (If LSP servers are desired they will need to be installed)
    * For C and C++ files clangd is recommended (Part of LLVM)
    * For Python files pyls is recommended
    * For Tex files texlab is recommended

### Check out Wiki for more specific information about setting up certain workflows.

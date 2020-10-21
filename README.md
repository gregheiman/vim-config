# Vim-Config

My personal Vim configuration for Windows and MacOS.
Before beginning it is recommended to install CURL first.

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
    * coc-settings.json -> your vimfiles folder (Default ~/vimfiles/)
    * /after/ directory -> your vimfiles folder
    * /autoload/ directory -> your vimfiles folder
4. Start Vim.
    * Vim-Plug shouldn't have to be installed (It's in the /autoload/ directory). 
    However, if it does need to be installed it should automatically install through 
    CURL and run :PlugInstall automatically, but if not install 
    [Vim-Plug](https://github.com/junegunn/vim-plug) yourself (follow the instructions on the page). 
    Then run :PlugInstall upon launching Vim for the first time.
5. Restart Vim.
6. Profit.

## Installation for MacOS

1. Install MacVim from [here](https://github.com/macvim-dev/macvim/releases/tag/snapshot-161).
2. Clone this repository into your home folder.
3. Create symlinks for the following files
  * Symlink command:
    ```
    ln -s Link Target
    ```

    * .vimrc -- your main Vim folder (For chocolatey C:/tools/vim)
    * coc-settings.json -> your vimfiles folder (Default ~/vimfiles/)
    * /after/ directory -> your vimfiles folder
    * /autoload/ directory -> your vimfiles folder
4. Start MacVim.
5. Start Vim.
    * Vim-Plug shouldn't have to be installed (It's in the /autoload/ directory). 
    However, if it does need to be installed it should automatically install through 
    CURL and run :PlugInstall automatically, but if not install 
    [Vim-Plug](https://github.com/junegunn/vim-plug) yourself (follow the instructions on the page). 
    Then run :PlugInstall upon launching Vim for the first time.
6. Restart MacVim.
7. Profit.

## Installation for Linux

1. Install Vim through your package manager.
2. Clone this repository into your home folder.
3. Create symlinks for the following files
  * Symlink command:
    ```
    ln -s Link Target
    ```

    * .vimrc -- your main Vim folder (For chocolatey C:/tools/vim)
    * coc-settings.json -> your vimfiles folder (Default ~/vimfiles/)
    * /after/ directory -> your vimfiles folder
    * /autoload/ directory -> your vimfiles folder
4. Start Vim.
5. Start Vim.
    * Vim-Plug shouldn't have to be installed (It's in the /autoload/ directory). 
    However, if it does need to be installed it should automatically install through 
    CURL and run :PlugInstall automatically, but if not install 
    [Vim-Plug](https://github.com/junegunn/vim-plug) yourself (follow the instructions on the page). 
    Then run :PlugInstall upon launching Vim for the first time.
6. Restart Vim.
7. Profit.

## Dependencies
You will need some tools to take advantage of some of the features in my .vimrc.

**Tools include:**

* Git (Needed in order to clone and maintain your .vimrc)
* LLVM (Includes Clang for compiling C files and Clangd language server)
* Python (Needed to run Python files)
* Java JDK (Needed to run Java files)
* Universal-Ctags (Needed in order for Tagbar to work and for tagging files)
* CURL (This one must be installed beforehand in order for Vim-Plug to
automatically install)
* MinGW-W64 or MinGW (Optional (Can use Clang as C compiler). 
Windows Only. Windows port of GCC for compiling C files)
* NodeJS, NPM, and Yarn (Optional. Used for web development)
* ESLint (Optional. Helps with linting JS files.)


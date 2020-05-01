# Vim-Config

My personal Vim configuration for Windows and MacOS.
Before beginning it is recommended to install CURL first.

## Installation for Windows

1. Install Vim from [here](https://github.com/vim/vim-win32-installer/releases).
2. Clone this repository into your Vim directory.
3. Start Vim.
4. Vim-Plug should install through CURL and run :PlugInstall automatically, but if not
install [Vim-Plug](https://github.com/junegunn/vim-plug) yourself
(follow the instructions on the page). Then run :PlugInstall upon launching
Vim for the first time
5. Place coc-settings.json into "C:/users/'username'/vimfiles" folder or create
a symlink to that location.
6. Restart Vim.
7. Profit.

## Installation for MacOS

1. Install MacVim from [here](https://github.com/macvim-dev/macvim/releases/tag/snapshot-161).
2. Clone this repository into your home folder.
3. Open up a terminal of your choice and run the following commands to symlink
.vimrc to the home directory:

```
ln -s ~/Vim-Config/.vimrc ~/.vimrc
```

4. Start MacVim.
5. Vim-Plug should install through CURL and run :PlugInstall automatically, but if not
install [Vim-Plug](https://github.com/junegunn/vim-plug) yourself
(follow the instructions on the page). Then run :PlugInstall upon launching
MacVim for the first time.
6. Place coc-settings.json into ~/.vim folder.
7. Restart MacVim.
8. Profit.

## Dependencies
You will need some tools to take advantage of some of the features in my .vimrc.

**Tools include:**

* LLVM (Needed to run C and C++ files)
* Python (Needed to run Python files)
* Java JDK (Needed to run Java files)
* Universal-Ctags (Needed in order for Tagbar to work and for tagging files)
* CURL (This one must be installed beforehand in order for Vim-Plug to
automatically install)
* MinGW-W64 or MinGW (Windows Only. Contains C and C++ compilers)
* Git (Needed in order to clone and maintain your .vimrc)
* NodeJS, NPM, and Yarn (Needed for running React and for finishing the install
on markdown-preview)
* ESLint (Optional. Helps with linting JS files.)


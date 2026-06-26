Setup dotfiles/ git repo
add the files that you want and delete the original
e.g. `cp ~/.zshrc ~/dotfiles/.zshrc && rm ~/.zshrc`
the file structure should be the same
e.g. `cp -r ~/.config/yazi ~/dotfiles/.config/yazi && rm -rf ~/.config/yazi`
then remap them using `stow .` inside ~/dotfiles
this creates symlinks
[Ref](https://www.youtube.com/watch?v=y6XCebnB9gs)

To use different folder (e.g. ~/Projects/dotfiles)
run `stow -t ~ .` from this folder

For the `.gitignore_global` file to work, use `git config --global core.excludesfile ~/.gitignore_global`

TODO:
1. Update file structure to
```
dotfiles/
├── home/
│   ├── .zshrc
│   └── .config/
└── etc/
    └── hosts
```
2. install with
```sh
#!/bin/sh
set -e

stow -t "$HOME" home
sudo stow -t / etc
```

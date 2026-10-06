[How Dotfiles works](https://www.youtube.com/watch?v=y6XCebnB9gs)

## MAC

```sh
cd apple
stow -t "$HOME" home
sudo stow -t /etc etc
```

## Android
repo must be cloned as `~/dots` (`.bashrc` hardcodes `$HOME/dots/moto/bin`)
install with
```sh
cd moto
stow -t ~ home
```
`moto/bin` is not stowed, `.bashrc` puts it on PATH as `$HOME/dots/moto/bin`
for a new setup see `moto/seed`

For the `.gitignore_global` file to work, use `git config --global core.excludesfile ~/.gitignore_global`

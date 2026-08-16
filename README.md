[How Dotfiles works](https://www.youtube.com/watch?v=y6XCebnB9gs)

## MAC

```sh
cd apple
stow -t "$HOME" home
sudo stow -t /etc etc
```

## Android
install with
```sh
cd moto
stow -t ~ .
```

For the `.gitignore_global` file to work, use `git config --global core.excludesfile ~/.gitignore_global`

# dotfiles

macOS, managed with GNU Stow, Rosé Pine Moon everywhere.

## New machine

```sh
git clone git@github.com:hvieira512/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./bootstrap.sh
```

Installs Homebrew and the Brewfile, stows every package into `~`, builds the bat
theme cache and installs the tmux plugins. Safe to re-run.

## Packages

| Package                    | What                                                    |
| -------------------------- | ------------------------------------------------------- |
| `zsh`                      | vi mode, fzf, zoxide, aliases, `mqsub`                  |
| `tmux`                     | vim-style panes and copy mode, rose-pine bar            |
| `nvim`                     | lazy.nvim config, plugins float to latest               |
| `ghostty`                  | font, theme, translucency                               |
| `git`                      | delta with the vendored themes, rose-pine syntax        |
| `lazygit`, `lazydocker`    | matching borders and selection                          |
| `starship`                 | default layout, palette only                            |
| `bat`, `btop`, `superfile` | themes                                                  |
| `claude`                   | notification hook and statusline script                 |
| `karabiner`                | caps lock and `§` remaps for the PT keyboard, iMac only |

## Two machines

The Brewfile holds only what both machines use. Personal laptop apps stay out
of it; `brewdrift` lists what is installed here but not in the Brewfile.
Karabiner is behind a hostname conditional because the MacBook has a US
keyboard and swaps caps lock in System Settings.

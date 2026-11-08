# ~/.config/bash/shell.sh — общие настройки оболочки (репозиторий configs), подключается из ~/.bashrc.
export PATH="$HOME/.local/bin:$PATH"

# neovim — редактор по умолчанию везде
export EDITOR=nvim
export VISUAL=nvim
export MANPAGER="nvim +Man!"

# Имена команд в Ubuntu: fd-find → fdfind, bat → batcat.
alias fd='fdfind'
alias bat='batcat'

command -v fzf >/dev/null && eval "$(fzf --bash)"

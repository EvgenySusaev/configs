# ~/.config/bash/shell.sh — общие настройки оболочки (роль dev_dotfiles), подключается из ~/.bashrc.
export PATH="$HOME/.local/bin:$PATH"

# neovim — редактор по умолчанию везде
export EDITOR=nvim
export VISUAL=nvim
export MANPAGER="nvim +Man!"
alias vi='nvim'
alias vim='nvim'

# Имена команд в Ubuntu: fd-find → fdfind, bat → batcat.
alias fd='fdfind'
alias bat='batcat'

command -v fzf >/dev/null && eval "$(fzf --bash)"

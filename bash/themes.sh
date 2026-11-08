# Цветовые темы для консоли Linux (TTY, TERM=linux) — подключается из ~/.bashrc.
# В графическом терминале функции ничего не делают.
# Сменить тему в текущей консоли: вызвать tron_dillinger / tron_encom / forest_theme.

forest_theme() {
    if [ "$TERM" == "linux" ]; then
        printf '\e]P01a1e1a'
        printf '\e]P1c2725a'
        printf '\e]P27aaa6a'
        printf '\e]P3c4a265'
        printf '\e]P46a93a8'
        printf '\e]P59a82aa'
        printf '\e]P66aaa8a'
        printf '\e]P7c8c2b4'
        printf '\e]P83a4038'
        printf '\e]P9d4896e'
        printf '\e]PA92c282'
        printf '\e]PBd4b87a'
        printf '\e]PC82aabf'
        printf '\e]PDb09abf'
        printf '\e]PE82c2a0'
        printf '\e]PFe0dcd0'
    fi
}

tron_dillinger() {
    if [ "$TERM" = "linux" ]; then
        printf '\e]P00d0000'  # black
        printf '\e]P1e03010'  # red
        printf '\e]P28b1a00'  # green
        printf '\e]P3ff6600'  # yellow
        printf '\e]P46b0f0f'  # blue
        printf '\e]P5cc2020'  # magenta
        printf '\e]P6a01800'  # cyan
        printf '\e]P7ffddcc'  # white
        printf '\e]P81a0000'  # bright black
        printf '\e]P9ff4020'  # bright red
        printf '\e]PAb02800'  # bright green
        printf '\e]PBff8800'  # bright yellow
        printf '\e]PC8f1515'  # bright blue
        printf '\e]PDff2828'  # bright magenta
        printf '\e]PEcc2010'  # bright cyan
        printf '\e]PFffffff'  # bright white
        clear                 # перерисовать экран в новых цветах
    fi
}

tron_encom() {
    if [ "$TERM" = "linux" ]; then
        printf '\e]P0000d1a'  # black
        printf '\e]P100b4d8'  # red
        printf '\e]P2004466'  # green
        printf '\e]P300ffff'  # yellow
        printf '\e]P4001833'  # blue
        printf '\e]P50077aa'  # magenta
        printf '\e]P6003355'  # cyan
        printf '\e]P7c8eeff'  # white
        printf '\e]P8001122'  # bright black
        printf '\e]P900d4ff'  # bright red
        printf '\e]PA006688'  # bright green
        printf '\e]PB40ffff'  # bright yellow
        printf '\e]PC002244'  # bright blue
        printf '\e]PD00aadd'  # bright magenta
        printf '\e]PE0055aa'  # bright cyan
        printf '\e]PFffffff'  # bright white
        clear
    fi
}

# Тема по умолчанию
#if [ "$color_prompt" == yes ]; then
    forest_theme
#fi

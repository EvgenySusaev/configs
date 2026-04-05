tron_dillinger() {
    if [ "$TERM" = "linux" ]; then
        printf '\e]P0 0d0000'  # black
        printf '\e]P1 e03010'  # red
        printf '\e]P2 8b1a00'  # green
        printf '\e]P3 ff6600'  # yellow
        printf '\e]P4 6b0f0f'  # blue
        printf '\e]P5 cc2020'  # magenta
        printf '\e]P6 a01800'  # cyan
        printf '\e]P7 ffddcc'  # white
        printf '\e]P8 1a0000'  # bright black
        printf '\e]P9 ff4020'  # bright red
        printf '\e]PA b02800'  # bright green
        printf '\e]PB ff8800'  # bright yellow
        printf '\e]PC 8f1515'  # bright blue
        printf '\e]PD ff2828'  # bright magenta
        printf '\e]PE cc2010'  # bright cyan
        printf '\e]PF ffffff'  # bright white
        clear                  # убрать артефакты от escape-последовательностей
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

if [ "$color_prompt" = yes ]; then
    tron_dillinger
    clear
fi

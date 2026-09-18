#!/bin/bash

h=$(date +%H)
m=$(date +%M)
s=$(date +%S)

now=$((10#$h * 3600 + 10#$m * 60 + 10#$s))
left=$((86400 - now))

printf '%02d:%02d:%02d\n' $((left / 3600)) $(((left % 3600) / 60)) $((left % 60))

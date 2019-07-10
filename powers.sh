#!/usr/bin/env sh

make
gzdoom -iwad doom2 -file build/powers.pk3 -warp 1 +give PowerMantle +give PowerDoubleJump +give PowerLean

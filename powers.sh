#!/usr/bin/env sh

make
gzdoom -iwad doom2 -file build/mantling.pk3 -warp 1 +give PowerMantle +give PowerDoubleJump

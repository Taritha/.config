#! /bin/sh

if [[ "$(bsp-layout get)" == "monocle" ]]; then
    bsp-layout previous
else
    bsp-layout set monocle
fi
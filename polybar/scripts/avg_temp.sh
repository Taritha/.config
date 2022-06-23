#!/bin/bash
TEMP=$(sensors | grep CPUTIN | cut -d "+" -f2)
TEMP="${TEMP:0:2}"
echo "${TEMP}°C  "
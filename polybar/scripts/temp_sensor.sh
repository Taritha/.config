#!/bin/bash

TEMP=$(sensors | grep Virtual_TEMP | cut -d "+" -f2)
TEMP="${TEMP:0:2}"
echo "懲 ${TEMP}°C"
#!/bin/bash

TEMP=$(sensors | grep edge | cut -c16-17)
POWER=$(sensors | grep PPT | cut -c14-16)

echo "${TEMP}°C   ${POWER}W"
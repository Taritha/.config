#!/bin/bash
TEMP=$(sensors | grep T_Sensor | cut -d "+" -f2)
TEMP="${TEMP:0:2}"
echo "${TEMP}"
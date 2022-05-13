#!/bin/bash
TEMP=$(sensors | grep Virtual_TEMP | cut -d "+" -f2)
TEMP="${TEMP:0:2}"

# if [[ "${TEMP}" -lt 25 ]]
# then
#     echo " ${TEMP}°C"

# elif [[ "${TEMP}" -lt 40 ]]
# then
#     echo " ${TEMP}°C"

# elif [[ "${TEMP}" -lt 50 ]]
# then
#     echo " ${TEMP}°C"

# else
#     echo " ${TEMP}°C"
# fi
echo "懲 ${TEMP}°C"
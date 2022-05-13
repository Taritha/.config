#!/bin/bash
TEMP=$(sensors | grep CPUTIN | cut -d "+" -f2)
TEMP="${TEMP:0:2}"

# if [[ "${TEMP}" -lt 25 ]]
# then
#     echo "CPU  ${TEMP}°C  "

# elif [[ "${TEMP}" -lt 50 ]]
# then
#     echo "CPU  ${TEMP}°C  "

# elif [[ "${TEMP}" -lt 75 ]]
# then
#     echo "CPU  ${TEMP}°C  "

# else
#     echo "CPU  ${TEMP}°C  "
# fi

echo "${TEMP}°C  "
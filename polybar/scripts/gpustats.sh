#!/bin/bash

TEMP=$(sensors | grep edge | cut -c16-17)
POWER=$(sensors | grep PPT | cut -c14-16)

# if [[ "${TEMP}" -lt 25 ]]
# then
#     echo "GPU  ${TEMP}°C   ${POWER}"

# elif [[ "${TEMP}" -lt 50 ]]
# then
#     echo "GPU  ${TEMP}°C   ${POWER}"

# elif [[ "${TEMP}" -lt 75 ]]
# then
#     echo "GPU  ${TEMP}°C   ${POWER}"

# else
#     echo "GPU  ${TEMP}°C   ${POWER}"
# fi

echo "${TEMP}°C   ${POWER}W"
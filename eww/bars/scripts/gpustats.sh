#! /bin/sh

CARD_TO_USE=$1
D_STAT=$2

GPU_BASIC="/sys/class/drm/card$1/device"
GPU_ADV="/sys/class/drm/card$1/device/hwmon/hwmon7"

# Display overall GPU usage%
get_usage() {
    cat "$GPU_BASIC/gpu_busy_percent"
}

# Displays overall VRAM usage%
get_mem_usage() {
    cat "$GPU_BASIC/mem_busy_percent"
}

get_mem_mb_usage() {
    MEM_GB=$(cat $GPU_BASIC/mem_info_vram_used)
    # Convert frequency in Hz to MHz
    echo "$(($MEM_GB / 1048576))"
}

# Displays current power used in Watts
get_power_usage() {
    cat $GPU_ADV/power1_average | sed 's/0//g'
}

# Get GPU package temperature
get_gpu_temp() {
    TEMP=$(cat $GPU_ADV/temp1_input)
    echo $(($TEMP / 1000))
}

# Get GPU hotspot/junction temperature
get_gpu_hotspot_temp() {
    TEMP=$(cat $GPU_ADV/temp2_input)
    echo $(($TEMP / 1000))
}

# Gets GPU VRAM frequency
get_gpu_corefreq() {
    FREQ_INHZ=$(cat $GPU_ADV/freq1_input)
    # Convert frequency in Hz to MHz
    echo "$(($FREQ_INHZ / 1000000))"
}

# Gets GPU memory frequency
get_gpu_memfreq() {
    FREQ_INHZ=$(cat $GPU_ADV/freq2_input)
    # Convert frequency in Hz to MHz
    echo "$(($FREQ_INHZ / 1000000))"
}

# Displays GPU vendor
get_gpu_name() {
    cat "$GPU_ADV/name"
}


case $D_STAT in
    "--use") get_usage;;
    "--mem_percent") get_mem_usage;;
    "--mem_mb") get_mem_mb_usage;;
    "--power") get_power_usage;;
    "--coretemp") get_gpu_temp;;
    "--hottemp") get_gpu_hotspot_temp;;
    "--corefreq") get_gpu_corefreq;;
    "--memfreq") get_gpu_memfreq;;
    "--name") get_gpu_vendor;;
esac
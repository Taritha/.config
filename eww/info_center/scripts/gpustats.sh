#! /bin/sh

# This works for amd gpus only
D_STAT=$1
GPU_QUERY="--format=csv,noheader --query-gpu"

# Display overall GPU usage%
get_usage() {
    nvidia-smi $GPU_QUERY=utilization.gpu | sed 's/%//g' | xargs
}

# Displays overall VRAM usage%
get_mem_usage() {
    nvidia-smi $GPU_QUERY=utilization.memory | sed 's/%//g' | xargs
}

# Display memory used (in MiB)
get_mem_mb_usage() {
    nvidia-smi $GPU_QUERY=memory.used | sed 's/[[:alpha:]]//g' | xargs
}

# Display total memory (in MiB)
get_mem_mb_total() {
    nvidia-smi $GPU_QUERY=memory.total | sed 's/[[:alpha:]]//g' | xargs
}

# Displays current power used in Watts
get_power_usage() {
    nvidia-smi $GPU_QUERY=power.draw | sed 's/W//g' | xargs
}

# Get cap on GPU power (though it can and often goes above this)
# This isn't really a thing on non-kepler nvidia cards so I just set it to 100W for the mobile 3080 ti lol
get_power_cap() {
    echo "100"
}

# Get GPU package temperature
get_gpu_temp() {
    nvidia-smi $GPU_QUERY=temperature.gpu
}

# Serves as a soft maximum for gpu temp 
get_gpu_crittemp() {
    echo "100"
}

# Gets GPU core frequency
get_gpu_corefreq() {
    nvidia-smi $GPU_QUERY=clocks.gr | sed 's/[[:alpha:]]//g' | xargs
}

# Gets GPU memory frequency
get_gpu_memfreq() {
    nvidia-smi $GPU_QUERY=clocks.mem | sed 's/[[:alpha:]]//g' | xargs
}

# Displays GPU vendor
get_gpu_name() {
    nvidia-smi $GPU_QUERY=name
}


case $D_STAT in
    "--use") get_usage;;
    "--mem_percent") get_mem_usage;;
    "--mem_mb") get_mem_mb_usage;;
    "--mem_total") get_mem_mb_total;;
    "--power") get_power_usage;;
    "--pcap") get_power_cap;;
    "--coretemp") get_gpu_temp;;
    "--crittemp") get_gpu_crittemp;;
    "--corefreq") get_gpu_corefreq;;
    "--memfreq") get_gpu_memfreq;;
    "--name") get_gpu_name;;
esac
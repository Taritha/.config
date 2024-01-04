#!/bin/bash

# credits to adi1090x

PREV_TOTAL=0
PREV_IDLE=0
cpuFile="/tmp/.cpu_usage"

get_cpu() {
	if [[ -f "${cpuFile}" ]]; then
		fileCont=$(cat "${cpuFile}")
		PREV_TOTAL=$(echo "${fileCont}" | head -n 1)
		PREV_IDLE=$(echo "${fileCont}" | tail -n 1)
	fi

	CPU=(`cat /proc/stat | grep '^cpu '`) # Get the total CPU statistics.
	unset CPU[0]                          # Discard the "cpu" prefix.
	IDLE=${CPU[4]}                        # Get the idle CPU time.

	# Calculate the total CPU time.
	TOTAL=0

	for VALUE in "${CPU[@]:0:4}"; do
		let "TOTAL=$TOTAL+$VALUE"
	done

	if [[ "${PREV_TOTAL}" != "" ]] && [[ "${PREV_IDLE}" != "" ]]; then
		# Calculate the CPU usage since we last checked.
		let "DIFF_IDLE=$IDLE-$PREV_IDLE"
		let "DIFF_TOTAL=$TOTAL-$PREV_TOTAL"
		let "DIFF_USAGE=(1000*($DIFF_TOTAL-$DIFF_IDLE)/$DIFF_TOTAL+5)/10"
		echo "${DIFF_USAGE}"
	else
		echo "?"
	fi

	# Remember the total and idle CPU times for the next check.
	echo "${TOTAL}" > "${cpuFile}"
	echo "${IDLE}" >> "${cpuFile}"
}

# Continuously updates cpu core values
get_corevals() {
    cpu_view="$(grep '^cpu.' /proc/stat; ps -eo '%p|%c|%C|' -o "%mem" -o '|%a' --sort=-%cpu | head -11 | tail -n +2)"
    prev_totals=()
    prev_idles=()

    # Popualtes arrays first
    while IFS= read -r line; do
        parsed="$(echo $line | cut -d ' ' -f1-8)"
        if [[ "$(echo $parsed | cut -d ' ' -f1)" == "cpu" ]]; then
            continue 1
        fi
        if [[ "$(echo $parsed | cut -d ' ' -f1)" == "cpu"* ]]; then
            arr=( $(echo $parsed) )
            total="$((${arr[1]} + ${arr[2]} + ${arr[3]} + ${arr[4]} + ${arr[5]} + ${arr[6]} + ${arr[7]}))"
            prev_totals+=($total)
            prev_idles+=(${arr[4]})
        fi
    done <<< "$cpu_view"

    # Uses 1s temporal difference to calculate core usage
    while sleep 2; do
        cpu_view="$(grep '^cpu.' /proc/stat; ps -eo '%p|%c|%C|' -o "%mem" -o '|%a' --sort=-%cpu | head -11 | tail -n +2)"
        i=0
        OUTPUT=()

        while IFS= read -r line; do
            parsed="$(echo $line | cut -d ' ' -f1-8)"

            # Skip overall CPU status
            if [[ "$(echo $parsed | cut -d ' ' -f1)" == "cpu" ]]; then
                continue 1
            fi
            if [[ "$(echo $parsed | cut -d ' ' -f1)" == "cpu"* ]]; then
                arr=( $(echo $parsed) )
                total="$((${arr[1]} + ${arr[2]} + ${arr[3]} + ${arr[4]} + ${arr[5]} + ${arr[6]} + ${arr[7]}))"

                # Calculate difference between result from 1s ago and now
                diff_total=$(($total - ${prev_totals[i]}))
                diff_idle=$((${arr[4]} - ${prev_idles[i]}))

                prev_totals[i]=$total
                prev_idles[i]=${arr[4]}
                
                # Final core usage can then be calculated with differences
                core_usage="$(((1000 * ($diff_total - $diff_idle) / $diff_total + 5) / 10))"
                OUTPUT+=($core_usage)

                i=$(($i+1))
            fi
        done <<< "$cpu_view"

        OUTSTRING=''
        # Outputs cores as json container for eww
        for i in ${!OUTPUT[@]}; do
            # Do not echo comma after last element
            if [[ "$i" != "$((${#OUTPUT[@]} - 1))" ]]; then
                OUTSTRING+="${OUTPUT[i]}, "
            else
                OUTSTRING+="${OUTPUT[i]}"
            fi
        done
        echo "[$OUTSTRING]"
    done
}

# Return json array of core numbers
get_cpus() {
    CPUS="$(cat /proc/cpuinfo | grep MHz | tr -d "MHz" | sed "s/[^A-Z^a-z]*//g")"
    COUNT=()

    while IFS= read -r line; do
        COUNT+=($line)
    done <<< "$CPUS"

    OUTSTRING=""

    for i in ${!COUNT[@]}; do
        if [[ "$i" != "$((${#COUNT[@]} - 1))" ]]; then
            OUTSTRING+="$i, "
        else
            OUTSTRING+="$i"
        fi
    done
    
    echo "[$OUTSTRING]"
}


# Gets frequencies of CPU cores
get_cpu_freqs() {
    FREQS="$(cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq)"
    F_ARRAY=()

    while IFS= read -r line; do
        F_ARRAY+=($(($line / 1000)))
    done <<< "$FREQS"

    OUTSTRING=""

    for i in ${!F_ARRAY[@]}; do
        if [[ "$i" != "$((${#F_ARRAY[@]} - 1))" ]]; then
            OUTSTRING+="${F_ARRAY[i]}, "
        else
            OUTSTRING+="${F_ARRAY[i]}"
        fi
    done

    echo "[$OUTSTRING]"
}

if [[ "$1" == "--cpu" ]]; then
    get_cpu
elif [[ "$1" == "--cores" ]]; then
    get_corevals
elif [[ "$1" == "--cpus" ]]; then
    get_cpus
elif [[ "$1" == "--freqs" ]]; then
    get_cpu_freqs
fi
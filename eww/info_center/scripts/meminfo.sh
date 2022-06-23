#! /bin/sh

get_memtotal() {
    TOTAL=$(cat /proc/meminfo | grep MemTotal | sed s/[^[:digit:]+._-]//g)
    # Converts total (in kB) in mB
    echo "$(($TOTAL / 1024))"
}

get_memfree() {
    FREE=$(cat /proc/meminfo | grep MemFree | sed s/[^[:digit:]+._-]//g)
    # Converts total (in kB) in mB
    echo "$(($FREE / 1024))"
}

get_memfree
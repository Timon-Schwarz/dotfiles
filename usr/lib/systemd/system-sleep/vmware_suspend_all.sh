#! /bin/bash

set -eu

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <period> <action>"
    exit 1
fi

period=$1
action=$2

echo "vmware system-sleep hook argv: ${period} ${action}"

if ! command -v vmrun &>/dev/null; then
    echo "command not found: vmrun"
fi

if [[ "${period}" = "pre" ]]; then
    readarray -t vms < <(vmrun list | tail -n +2)

    echo "Number of running VMs: ${#vms[@]}"

    if [[ ${#vms[@]} -eq 0 ]]; then
        exit
    fi

    for vm in "${vms[@]}"; do
        echo -n "Suspending ${vm}... "
        vmrun suspend "${vm}"
        echo "done"
    done

    sleep 1
else
    echo "Nothing to do"
fi

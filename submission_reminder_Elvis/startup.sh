#!/bin/bash
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
reminder_script="$script_dir/app/reminder.sh"

if [ ! -f "$script_dir/config/config.env" ]; then
    echo "Error: config.env not found."
    exit 1
fi

bash "$reminder_script"

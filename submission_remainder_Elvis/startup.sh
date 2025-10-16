#!/usr/bin/bash
#check if file exists in the directory. we use config because the app cannot run without config.env file.

if [  ! -f "$config/config.env"  ]; then
    echo "Error occurred. Run this script from submission_remainder dir"
    exi 1
fi
#Run the reminder.sh script
bash app/reminder.sh

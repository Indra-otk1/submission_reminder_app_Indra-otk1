#!/bin/bash
source ./config/config.env
source ./modules/functions.sh

submissions_file="$(dirname "$0")/../assets/submissions.txt"

echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file

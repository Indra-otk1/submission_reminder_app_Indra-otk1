#!/bin/bash
# Script to update assignment name in config file and rerun the reminder app

# Define key variables
parent="submission_reminder_*/"
star="startup.sh"
config="./submission_reminder_*/config/config.env"
continuation="y"
assignment_name=""

# Function to update the assignment and run the app
copilot_function() {
    assignment="$1"

    # Check if the main directory exists
    if [ ! -d $parent ]; then
        echo "Directory not found. Run create_environment.sh first."
        exit 1
    else
        # Replace the assignment name in config.env
        sed -i "s/ASSIGNMENT=\".*\"/ASSIGNMENT=\"$assignment_name\"/" $config
        echo "Processing '$assignment' assignment..."

        # Navigate to app directory and run startup.sh
        cd $parent
        if [ ! -f $star ]; then
            echo "Error: $star not found."
            exit 1
        else
            ./$star
            cd ..
        fi
    fi
}

# Loop to allow user to check multiple assignments
while [[ "$continuation" == "y" || "$continuation" == "Y" ]]; do
    echo " "
    echo "Which assignment do you want to check?"
    echo "Examples: Shell Navigation, Shell Basics, Git"

    read -p "Enter the assignment name: " assignment_name
    copilot_function "$assignment_name"

    echo " "
    read -p "Do you want to analyze another assignment (y/n): " continuation
done

# Exit message
echo "Exiting"


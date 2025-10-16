#!/usr/bin/bash
# Script to set up the submission reminder environment

# Ask for user's name and create main directory
read -p "Enter your name: " yourname
parent_dir="submission_reminder_${yourname}"
mkdir -p "$parent_dir"

# Create subdirectories
mkdir -p "$parent_dir/app"
mkdir -p "$parent_dir/modules"
mkdir -p "$parent_dir/assets"
mkdir -p "$parent_dir/config"

# Define paths
app="$parent_dir/app"
modules="$parent_dir/modules"
assets="$parent_dir/assets"
config="$parent_dir/config"

# Create config.env file
cat > "$config/config.env" << 'EOF'
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF

# Create reminder.sh file
cat > "$app/reminder.sh" << 'EOF'
#!/bin/bash
source ./config/config.env
source ./modules/functions.sh

submissions_file="$(dirname "$0")/../assets/submissions.txt"

echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
EOF

# Create functions.sh file
cat > "$modules/functions.sh" << 'EOF'
#!/bin/bash

# Function to check for students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    while IFS=, read -r student assignment status; do
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file")
}
EOF

# Create submissions.txt file
cat > "$assets/submissions.txt" << 'EOF'
student, assignment, submission status
Nziza, Git, submitted
Huguette, Shell Basics, not submitted
Divine, Git, submitted
Keza, Shell Basics, not submitted
Carla, Shell Navigation, not submitted
Ineza, Shell Navigation, submitted
Arnaud, Git, submitted
Igor, Shell Basics, not submitted
Lebron, Shell Basics, submitted
Miguel, Git, not submitted
Creed, Shell Navigation, submitted
EOF

# Create startup.sh file
cat > "$parent_dir/startup.sh" << 'EOF'
#!/bin/bash
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
reminder_script="$script_dir/app/reminder.sh"

if [ ! -f "$script_dir/config/config.env" ]; then
    echo "Error: config.env not found."
    exit 1
fi

bash "$reminder_script"
EOF

# Make .sh files executable
chmod +x $app/*
chmod +x $modules/*
cd $parent_dir
chmod +x startup.sh
cd ..

# Display completion message
echo "Environment created successfully!!."
echo "To check if the app works:"
echo "cd $parent_dir && ./startup.sh"


#!/usr/bin/bash		

#When it starts, it should prompt the user for their name and create a directory named submission_reminder_{yourName}.

read -p "Enter your name: " yourname
#create the directory aswell as the subdirectories with their contents

parent_dir="submission_remainder_${yourname}"
mkdir -p "$parent_dir"

#create subdirectories
mkdir -p "$parent_dir/app"
mkdir -p "$parent_dir/modules"
mkdir -p "$parent_dir/assets"
mkdir -p "$parent_dir/config"

#creating the files and their contents

app="$parent_dir/app"
modules="$parent_dir/modules"
assets="$parent_dir/assets"
config="$parent_dir/config"

#creating config.env and its contents
cat > "$config/config.env" << 'EOF'
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF

#creating reminder.sh and its contents
cat > "$app/reminder.sh" << 'EOF'
#!/bin/bash

source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining till submittion: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions
EOF

#create functions.sh and its contents
cat > "$modules/functions.sh" << 'EOF'
#!/bin/bash

# Function to read files submitted and show students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment match and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
EOF

#create submissions.txt and its contents
cat > "$assets/submissions.txt" << 'EOF'
student, assignment, submission status
Patrick, Shell Basics, submitted
Gasaro, Git Hub, not submitted
Divine, Git, not submitted
Huegette, Shell Basics, submitted
Harry, Shell Navigation, submitted
Mwiza, Git, submitted
Samuel, Shell Basics, submitted
Anthony, shell Navigation, not submitted
Phillip, Git, submitted
Mitchel, Shell Basics, not submitted
Olatunji, Git Hub, not submitted
EOF

cat > "$parent_dir/startup.sh" << 'EOF'
#!/usr/bin/bash
#check if file exists in the directory. we use config because the app cannot run without config.env file.

if [  ! -f "$config/config.env"  ]; then
    echo "Error occurred. Run this script from submission_remainder dir"
    exi 1
fi
#Run the reminder.sh script
bash app/reminder.sh
EOF

#Give .sh files excecution permissions
chmod +x $app/*
chmod +x $modules/*
cd $parent_dir
chmod +x startup.sh
cd ..


echo "Environment has been created successfully!!"
echo "To check if the application runs:"
echo "cd $parent_dir && ./startup.sh"

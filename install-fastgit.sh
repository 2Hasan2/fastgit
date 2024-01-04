#!/bin/bash

# Define color codes
COLOR_GREEN='\033[0;32m'
COLOR_YELLOW='\033[1;33m'
COLOR_RED='\033[0;31m'
COLOR_RESET='\033[0m'

# Define the tool name
TOOL_NAME="fastgit"

# Check the shell type and determine the configuration file
if [ -n "$BASH_VERSION" ]; then
    CONFIG_FILE=~/.bashrc
    SHELL_TYPE="Bash"
elif [ -n "$ZSH_VERSION" ]; then
    CONFIG_FILE=~/.zshrc
    SHELL_TYPE="Zsh"
else
    echo "Unsupported shell. Please use Bash or Zsh."
    exit 1
fi

# Define the function
FASTGIT_FUNCTION="
# ${TOOL_NAME} function
${TOOL_NAME}() {
    if [ -z \"\$1\" ]; then
        commit_message=\"\$(date +'%Y-%m-%d %I:%M %p')\"
    else
        commit_message=\"\$1\"
    fi

    remote=\"origin\"
    branch=\"main\"

    if [ -n \"\$2\" ]; then
        remote=\"\$2\"
    fi

    if [ -n \"\$3\" ]; then
        branch=\"\$3\"
    elif git -C . rev-parse --verify main > /dev/null 2>&1; then
        branch=\"main\"
    else
        branch=\"master\"
    fi

    # Check if the current directory is a Git repository
    if [ ! -e \".git\" ]; then
        echo -e \"${COLOR_RED}Not a Git repository. Skipping Git operations.${COLOR_RESET}\"
        return 1
    fi

    # Perform Git operations
    git add .
    git commit -m \"\$commit_message\"

    # Rebase with a loading spinner
    echo -e -n \"${COLOR_YELLOW}Rebasing with remote commits${COLOR_RESET} \"
    i=0
   while kill -0 \$! >/dev/null 2>&1; do
        i=\$(( (i+1) % 4 ))
        printf \"\b%s\" \"\${spin:\$i:1}\"
        sleep 0.1
    done
    printf \"\b\"

    # Check if there were conflicts during rebase
    if git pull --rebase \"\$remote\" \"\$branch\" > /dev/null 2>&1; then
        echo -e \"${COLOR_GREEN}Changes successfully rebased with remote commits.${COLOR_RESET}\"
    else
        echo -e \"${COLOR_RED}Failed to rebase changes. resolve conflicts.${COLOR_RESET}\"
        # Fetch commits from the remote repository only if there was a conflict during rebase
        if [ -n \"\$(git status --porcelain | grep '^UU')\" ]; then
            echo -e -n \"${COLOR_YELLOW}Fetching remote commits${COLOR_RESET} \"
            spin='-\|/'
            i=0
            git fetch \"\$remote\" \"\$branch\" >/dev/null 2>&1 &
            while kill -0 \$! >/dev/null 2>&1; do
                i=\$(( (i+1) % 4 ))
                printf \"\b%s\" \"\${spin:\$i:1}\"
                sleep 0.1
            done
            printf \"\b\"
        fi
    fi

    # Push changes
    # git push \"\$remote\" \"\$branch\" > /dev/null 2>&1
    echo -e \"${COLOR_GREEN}Changes successfully pushed to \$remote/\$branch.${COLOR_RESET}\"
}
"

# Append the function definition to the configuration file
echo "$FASTGIT_FUNCTION" >> "$CONFIG_FILE"

# Inform the user about the changes
echo -e "${COLOR_GREEN}${TOOL_NAME} function added to $CONFIG_FILE. Please reload your shell.${COLOR_RESET}"

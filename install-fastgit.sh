#!/bin/bash

# Define color codes
COLOR_GREEN='\033[1;32m'
COLOR_YELLOW='\033[1;33m'
COLOR_RED='\033[1;31m'
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
# Spinner function
spinner() {
    local pid=\$1
    local delay=0.05
    local spinstr='|/-\\'
    tput civis
    while [ -d \"/proc/\$pid\" ]; do
        local temp=\$spinstr
        spinstr=\$(echo \$spinstr | sed 's/.\(.*\)/\1/')
        printf \"%c\" \"\$temp\"
        sleep \$delay
        printf \"\\b\\b\\b\"
    done
    tput cnorm
    printf \"   \\b\\b\\b\"
}

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

    # Rebase with the loading spinner
    echo -n -e \"${COLOR_YELLOW}Rebasing changes...${COLOR_RESET}\t\"
    git pull --rebase \"\$remote\" \"\$branch\" > /dev/null 2>&1 &
    spinner \$!
    wait \$!

    # Check if there were conflicts during rebase
    if [ $? -eq 0 ]; then
        echo -e \"${COLOR_GREEN}Changes successfully rebased with remote commits.${COLOR_RESET}\n\"
    else
        echo -e \"${COLOR_RED}Failed to rebase changes. Resolve conflicts.${COLOR_RESET}\n\"
        # Fetch commits from the remote repository only if there was a conflict during rebase
        if [ -n \"\$(git status --porcelain | grep '^UU')\" ]; then
            echo -n -e \"${COLOR_YELLOW}Fetching remote commits...${COLOR_RESET}\t\"
            git fetch \"\$remote\" \"\$branch\" >/dev/null 2>&1
            echo -e "${COLOR_YELLOW}Done${COLOR_RESET}\n"
        fi
    fi

    # Push changes
    git push \"\$remote\" \"\$branch\" > /dev/null 2>&1
    echo -e \"${COLOR_GREEN}Changes successfully pushed to \$remote/\$branch.${COLOR_RESET}\n\"
}
"

# Append the function definition to the configuration file
echo "$FASTGIT_FUNCTION" >> "$CONFIG_FILE"

# Inform the user about the changes
echo -e "${COLOR_GREEN}${TOOL_NAME} function added to $CONFIG_FILE. Please reload your shell.${COLOR_RESET}"

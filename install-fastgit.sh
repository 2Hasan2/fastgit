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
    case \$1 in
        clone)
            if [ -z \"\$2\" ]; then
                echo -e \"${COLOR_RED}Please provide a repository URL.${COLOR_RESET}\"
                return 1
            fi

            repo_url=\"\$2\"

            # Clone repository
            echo -e -n \"${COLOR_YELLOW}Cloning repository from \$repo_url.${COLOR_RESET} \n\"
            git clone \"\$repo_url\" .
            printf \"\n\"
            ;;
        \"clone\")
            if [ -z \"\$2\" ]; then
                echo -e \"${COLOR_RED}Please provide a commit message.${COLOR_RESET}\"
                return 1
            fi

            commit_message=\"\$2\"

            # Check if the current directory is a Git repository
            if [ ! -e \".git\" ]; then
                echo -e \"${COLOR_RED}Not a Git repository. Skipping Git operations.${COLOR_RESET}\"
                return 1
            fi

            # Perform Git operations
            git add .
            git commit -m \"\$commit_message\"

            # Rebase with a loading spinner
            echo -e -n \"${COLOR_YELLOW}Rebasing with remote commits.${COLOR_RESET} \n\"
            i=0 
            while kill -0 \$! >/dev/null 2>&1; do
                i=\$(( (i+1) % 4 ))
                printf \"\b%s\" \"\${spin:\$i:1}\"
                sleep 0.1
            done
            printf \"\b\n\"

            # Check if there were conflicts during rebase
            if git pull --rebase > /dev/null 2>&1; then
                echo -e \"${COLOR_GREEN}Changes successfully rebased with remote commits.${COLOR_RESET}\n\"
            else
                echo -e \"${COLOR_RED}Failed to rebase changes. Resolve conflicts.${COLOR_RESET}\n\"
                # Fetch commits from the remote repository only if there was a conflict during rebase
                if [ -n \"\$(git status --porcelain | grep '^UU')\" ]; then
                    echo -e -n \"${COLOR_YELLOW}Fetching remote commits${COLOR_RESET} \"
                    spin='-\|/'
                    i=0
                    git fetch origin main >/dev/null 2>&1 &
                    while kill -0 \$! >/dev/null 2>&1; do
                        i=\$(( (i+1) % 4 ))
                        printf \"\b%s\" \"\${spin:\$i:1}\"
                        sleep 0.1
                    done
                    printf \"\b\n\"
                fi
            fi

            # Push changes
            git push origin main > /dev/null 2>&1
            echo -e \"${COLOR_GREEN}Changes successfully pushed to origin/main.${COLOR_RESET}\n\"
            ;;
        *)
            echo -e \"${COLOR_RED}Invalid command. Use 'clone' for cloning a repository or provide a commit message.${COLOR_RESET}\"
            return 1
            ;;
    esac
}
"

# Append the function definition to the configuration file
echo "$FASTGIT_FUNCTION" >> "$CONFIG_FILE"

# Inform the user about the changes
echo -e "${COLOR_GREEN}${TOOL_NAME} function added to $CONFIG_FILE. Please reload your shell.${COLOR_RESET}"

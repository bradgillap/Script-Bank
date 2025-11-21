#!/bin/bash
#
# Script to list all currently installed Ollama models and update them.
# The 'ollama pull' command automatically checks for a newer version
# and downloads it if one is available.

# --- Configuration ---
# Set the minimum required version for the models list.
# The `ollama list` command's first line is a header, which we skip.
MODEL_LIST_COMMAND="ollama list"

# --- Function Definitions ---

# Function to check if the 'ollama' command is available
check_ollama() {
    if ! command -v ollama &> /dev/null
    then
        echo "Error: The 'ollama' command could not be found." >&2
        echo "Please ensure Ollama is installed and in your system's PATH." >&2
        exit 1
    fi
}

# --- Main Execution ---
echo "================================================="
echo "Ollama Model Update Script"
echo "================================================="

# 1. Check prerequisite
check_ollama

echo "Fetching list of installed models..."

# 2. Get the list of models
# We pipe the output of 'ollama list':
# - Skip the first line (header) using 'awk'
# - Print only the first column (the model name)
MODELS=$($MODEL_LIST_COMMAND | awk 'NR>1 {print $1}')

# Check if any models were found
if [ -z "$MODELS" ]; then
    echo "No models found to update."
    exit 0
fi

echo "Found the following models to check for updates:"
echo "-------------------------------------------------"
echo "$MODELS"
echo "-------------------------------------------------"
echo ""

# 3. Loop through the models and initiate the pull/update process
for MODEL_NAME in $MODELS; do
    echo ">>> Attempting to update model: $MODEL_NAME <<<"
    
    # Run 'ollama pull'. This command checks the server for updates.
    # It only downloads if a newer version or a missing layer is detected.
    ollama pull "$MODEL_NAME"
    
    # Check the exit status of the pull command
    if [ $? -eq 0 ]; then
        echo "Successfully checked/updated $MODEL_NAME."
    else
        echo "Warning: Failed to pull/update $MODEL_NAME. Check the error output above." >&2
    fi
    echo "" # Add a newline for readability
done

echo "================================================="
echo "Update process completed."
echo "================================================="

exit 0

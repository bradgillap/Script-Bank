#!/bin/bash

# ==============================================================================
# Guacamole Connection Exporter with TOTP Support (Updated for robust API calls)
# ------------------------------------------------------------------------------
# NOTE: Requires 'curl' and 'jq' to be installed on your system.
# NOTE: Tested import name,protocol,hostname,password,port,private-key,
# passphrase,username,users,groups. 
# USAGE:
# 1. Update the variables below with your Guacamole instance details.
# 2. Run the script: bash guacamole_exporter.sh
# 3. Enter your current TOTP code when prompted.
# ==============================================================================

# --- CONFIGURATION (EDIT THESE) ---
GUAC_URL="http://localhost:8080/guacamole"
GUAC_USER="guacadmin"
GUAC_PASS=""
DATA_SOURCE="mysql" # Fallback data source (Will be overwritten if API provides it)
START_ID=1
END_ID=100
# ----------------------------------

# Check for required tools
if ! command -v curl &> /dev/null; then
    echo "Error: 'curl' is required but not installed." >&2
    exit 1
fi
if ! command -v jq &> /dev/null; then
    echo "Error: 'jq' is required but not installed. Install with 'sudo apt install jq' or 'brew install jq'." >&2
    exit 1
fi

echo "--- Guacamole Exporter Started ---"

# --- 1. Initial Login Check (/api/tokens) ---
echo "1/4. Attempting initial login check..."

# Use -w to capture the HTTP status code for debugging connectivity issues
LOGIN_OUTPUT=$(curl -s -X POST "${GUAC_URL}/api/tokens" \
    -w "\n%{http_code}" \
    -d "username=${GUAC_USER}&password=${GUAC_PASS}")

# Separate body and status code
AUTH_RESPONSE=$(echo "$LOGIN_OUTPUT" | head -n -1)
HTTP_STATUS=$(echo "$LOGIN_OUTPUT" | tail -n 1)

# Check for connection/API errors first (status 000 means connection failed)
if [ "$HTTP_STATUS" == "000" ]; then
    echo "Error: Connection failed. Check GUAC_URL or confirm Guacamole server is running and accessible." >&2
    exit 1
fi

# Check if the API is requesting the TOTP code
if echo "$AUTH_RESPONSE" | grep -q "TOTP"; then
    echo "   TOTP challenge received (HTTP ${HTTP_STATUS}). Proceeding to Step 2."
    
    # --- 2. TOTP Prompt and Final Token Acquisition ---
    read -p "2/4. Enter your current TOTP code: " TOTP_CODE
    
    echo "   Submitting TOTP code..."
    # Resubmit with username, password, AND the TOTP code in the form-data payload, capturing status again
    LOGIN_OUTPUT_TOTP=$(curl -s -X POST "${GUAC_URL}/api/tokens" \
      -w "\n%{http_code}" \
      -d "username=${GUAC_USER}&password=${GUAC_PASS}&guac-totp=${TOTP_CODE}")
      
    AUTH_RESPONSE=$(echo "$LOGIN_OUTPUT_TOTP" | head -n -1)
    HTTP_STATUS=$(echo "$LOGIN_OUTPUT_TOTP" | tail -n 1)

    if [ "$HTTP_STATUS" != "200" ]; then
        echo "Error: TOTP submission failed (HTTP ${HTTP_STATUS})." >&2
        echo "Server response:"
        echo "$AUTH_RESPONSE" | jq . 2>/dev/null || echo "$AUTH_RESPONSE"
        exit 1
    fi
else
    # If TOTP wasn't required, the first AUTH_RESPONSE already contains the token.
    # Check for authentication failure on the first step.
    if [ "$HTTP_STATUS" != "200" ]; then
        echo "Error: Initial login failed (HTTP ${HTTP_STATUS})." >&2
        echo "Server response (check for credential errors):"
        echo "$AUTH_RESPONSE" | jq . 2>/dev/null || echo "$AUTH_RESPONSE"
        exit 1
    fi
fi

# Extract and validate the final token and data source
FINAL_TOKEN=$(echo "$AUTH_RESPONSE" | jq -r '.authToken // empty')
DATA_SOURCE_EXTRACTED=$(echo "$AUTH_RESPONSE" | jq -r '.dataSource // empty')

if [ -z "$FINAL_TOKEN" ] || [ "$FINAL_TOKEN" == "null" ]; then
    echo "Error: Failed to retrieve Guacamole token after authentication attempts." >&2
    echo "This is unexpected after successful HTTP response (Status ${HTTP_STATUS}). Check if the server response is valid JSON." >&2
    echo "Server response (RAW for debugging):"
    echo "$AUTH_RESPONSE"
    exit 1
fi

# Update the global DATA_SOURCE variable if it was successfully extracted
if [ -n "$DATA_SOURCE_EXTRACTED" ]; then
    DATA_SOURCE="$DATA_SOURCE_EXTRACTED"
fi

echo "   Authentication successful. Final token acquired. Data Source: $DATA_SOURCE"

# --- 3. Export Connections (Loop ID 1 to 100 with two API calls per ID) ---
OUTPUT_DIR="./guac_exports_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$OUTPUT_DIR"
echo "3/4. Starting connection export (IDs ${START_ID} to ${END_ID}) into '${OUTPUT_DIR}/'"
echo "   Skipping non-existent IDs (404s)."

# Create array to hold all connections
CONNECTIONS_ARRAY="[]"

for i in $(seq "$START_ID" "$END_ID"); do
    
    # --- Step 3a: Fetch Metadata (Name, Users, Groups, Parent) ---
    # NOTE: Using Guacamole-Token header for improved compliance, as suggested by your reference.
    METADATA_OUTPUT=$(curl -s -X GET "${GUAC_URL}/api/session/data/${DATA_SOURCE}/connections/${i}" \
        -H "Guacamole-Token: ${FINAL_TOKEN}" \
        -w "\n%{http_code}")
    METADATA_RESPONSE=$(echo "$METADATA_OUTPUT" | head -n -1)
    METADATA_HTTP_CODE=$(echo "$METADATA_OUTPUT" | tail -n 1)

    # Use printf for zero-padding in the filename (e.g., connection_001.json)
    CONN_ID_PADDED=$(printf "%03d" "$i")
    OUTPUT_FILE_BASE="${OUTPUT_DIR}/connection_${CONN_ID_PADDED}"
    RAW_FILE="${OUTPUT_FILE_BASE}.raw"

    if [ "$METADATA_HTTP_CODE" == "200" ]; then
        # Check metadata response validity
        METADATA_JSON=$(echo "$METADATA_RESPONSE" | jq '.' 2>/dev/null)
        if [ $? -ne 0 ]; then
            echo "   [FAIL] ID ${i} - Invalid JSON metadata received (HTTP 200). Raw saved to ${RAW_FILE}" >&2
            echo "$METADATA_RESPONSE" > "${RAW_FILE}"
            continue
        fi

        CONNECTION_NAME=$(echo "$METADATA_JSON" | jq -r '.name // "unknown"')
        FILENAME_NAME=$(echo "$CONNECTION_NAME" | tr -c '[:alnum:]_-' '_')
        OUTPUT_FILE="${OUTPUT_FILE_BASE}_${FILENAME_NAME}.json"

        # --- Step 3b: Fetch Configuration (Hostname, Username, Parameters) ---
        # Try the correct API endpoint for configuration data
        CONFIG_OUTPUT=$(curl -s -X GET "${GUAC_URL}/api/session/data/${DATA_SOURCE}/connections/${i}/parameters" \
            -H "Guacamole-Token: ${FINAL_TOKEN}" \
            -w "\n%{http_code}")
        CONFIG_RESPONSE=$(echo "$CONFIG_OUTPUT" | head -n -1)
        CONFIG_HTTP_CODE=$(echo "$CONFIG_OUTPUT" | tail -n 1)
        
        if [ "$CONFIG_HTTP_CODE" == "200" ]; then
            # Check configuration response validity
            CONFIG_JSON=$(echo "$CONFIG_RESPONSE" | jq '.' 2>/dev/null)
            if [ $? -ne 0 ]; then
                echo "   [FAIL] ID ${i} - Configuration worked (200), but response was invalid JSON. Raw saved to ${RAW_FILE}" >&2
                echo "$CONFIG_RESPONSE" > "${RAW_FILE}"
                continue
            fi

            # 3c. Merge the two responses using jq and apply all requested modifications
            # CONFIG_JSON contains the parameters and protocol. METADATA_JSON contains everything else.
            CONNECTION_JSON=$(echo "$METADATA_JSON" | jq --argjson config_data "$CONFIG_JSON" '
                # Apply the configuration data from the second request (Crucial for parameters)
                .parameters = ($config_data // {}) |
                
                # Force parentIdentifier to "ROOT" (as requested)
                .parentIdentifier = "ROOT" |
                
                # Clean up the object for import (remove internal Guacamole fields)
                del(.identifier, .activeConnections, .lastActive, .connectionGroups, .state) |
                
                # Ensure users and groups are properly formatted
                .users = (if .users == null then [] else .users end) |
                .groups = (if .groups == null then [] else .groups end) |
                
                # Remove any group field that might exist (should use parentIdentifier)
                del(.group) |
                
                # Wrap the final object in an array [.]
                [.]
            ')

            # Append to connections array
            CONNECTIONS_ARRAY=$(echo "$CONNECTIONS_ARRAY" | jq --argjson conn "$CONNECTION_JSON" '. + $conn')
            echo "   [OK] Exported ID ${i} ('$CONNECTION_NAME') to ${OUTPUT_FILE} (Merged Config)"
        else
            # Failed to get configuration - if this persists, the API path in 3b needs adjustment.
            echo "   [FAIL] ID ${i} - Configuration request failed (HTTP ${CONFIG_HTTP_CODE}). Raw saved to ${RAW_FILE}" >&2
            echo "$CONFIG_RESPONSE" > "${RAW_FILE}"
        fi
    elif [ "$METADATA_HTTP_CODE" == "404" ]; then
        : # Skip non-existent connection IDs
    else
        echo "   [FAIL] ID ${i} - Metadata request failed with HTTP ${METADATA_HTTP_CODE}. Raw saved to ${RAW_FILE}" >&2
        echo "$METADATA_RESPONSE" > "${RAW_FILE}"
        ERROR_MSG=$(cat "${RAW_FILE}" | jq -r '.message // "No JSON error message."' 2>/dev/null)
        echo "     Error: ${ERROR_MSG}"
    fi

done

# Write the final combined JSON file
echo "$CONNECTIONS_ARRAY" | jq . > "${OUTPUT_DIR}/connections.json"
echo "   [OK] Combined connections written to ${OUTPUT_DIR}/connections.json"

# --- 4. Cleanup/Logout ---
echo "4/4. Revoking final token (logging out)..."
# Using Guacamole-Token header for the DELETE request as well
curl -s -X DELETE "${GUAC_URL}/api/session/tokens/${FINAL_TOKEN}" \
    -H "Guacamole-Token: ${FINAL_TOKEN}" > /dev/null

echo "---"
echo "Export complete. Check the '${OUTPUT_DIR}' directory for successful exports."
echo "Script finished."

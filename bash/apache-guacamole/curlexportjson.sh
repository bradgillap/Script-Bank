#!/bin/bash

# This will retrieve a connections json values through curl from guacamole on the cli of the guacamole server. Handy for building out a list of connections you wish to export for the future.

# --- CONFIGURATION ---
GUAC_HOST="http://localhost:8080/guacamole"  # Adjust if needed
GUAC_USER="guacadmin"
GUAC_PASS=""                                 # !! Replace with your actual password !!
CONNECTION_ID="01"                           # !! Replace with the ID of the connection !!
# ---------------------

# Prompt for the current TOTP code
read -p "Enter current TOTP code (6 digits): " TOTP_CODE

echo "Attempting initial token retrieval..."

# Step 1: Initial Token Request (will fail with TOTP error)
AUTH_RESPONSE=$(curl -s -X POST \
  "${GUAC_HOST}/api/tokens" \
  -d "username=${GUAC_USER}&password=${GUAC_PASS}")

# Check if the API is requesting the TOTP code
if echo "$AUTH_RESPONSE" | grep -q "TOTP.INFO_CODE_REQUIRED"; then
    echo "TOTP challenge received. Submitting code..."
    
    # Step 2: Submit the TOTP Code and get the final token
    AUTH_RESPONSE=$(curl -s -X POST \
      "${GUAC_HOST}/api/tokens" \
      -d "username=${GUAC_USER}&password=${GUAC_PASS}&guac-totp=${TOTP_CODE}")
fi

# Extract and validate the final token
TOKEN=$(echo "$AUTH_RESPONSE" | jq -r .authToken)
DATA_SOURCE=$(echo "$AUTH_RESPONSE" | jq -r .dataSource)

if [ "$TOKEN" == "null" ] || [ -z "$TOKEN" ]; then
    echo "ERROR: Failed to retrieve Guacamole token after TOTP submission." >&2
    echo "API Response: $AUTH_RESPONSE" >&2
    exit 1
fi

echo "Successfully authenticated. Token received. Data Source: $DATA_SOURCE"

# Step 3: Retrieve the Connection Details (Unchanged)
echo "Retrieving connection ID ${CONNECTION_ID}..."

CONNECTION_JSON=$(curl -s -X GET \
  -H "Guacamole-Token: $TOKEN" \
  "${GUAC_HOST}/api/session/data/${DATA_SOURCE}/connections/${CONNECTION_ID}" | jq .)

echo "--- Exported JSON for Connection ID ${CONNECTION_ID} ---"
echo "$CONNECTION_JSON"

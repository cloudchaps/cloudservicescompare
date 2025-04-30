#!/bin/bash
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    PROFILE_FILE="$HOME/.profile"
    BACKUP_FILE="$HOME/.profile.backup.$(date +%Y%m%d%H%M%S)"
    SED_COMMAND="sed -i"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    PROFILE_FILE="$HOME/.zshrc "
    BACKUP_FILE="$HOME/.zshrc.backup.$(date +%Y%m%d%H%M%S)"
    SED_COMMAND="sed -i ''"
else
    echo "❌ Unsupported OS: $OSTYPE"
    exit 1
fi

# Define input file
INPUT_FILE="servicePrincipal.json"

# Check if file exists
if [[ ! -f "$INPUT_FILE" ]]; then
  echo "❌ Input file '$INPUT_FILE' not found. Please place it in the same directory."
  exit 1
fi

# Azure variable patterns to remove
VARS=("ARM_CLIENT_ID" "ARM_CLIENT_SECRET" "ARM_SUBSCRIPTION_ID" "ARM_TENANT_ID" "# Azure credentials")

# Backup the profile file
cp "$PROFILE_FILE" "$BACKUP_FILE"
echo "🛡️ Backup created: $BACKUP_FILE"

# Remove matching lines
echo "🧹 Removed Azure-related environment variables from $PROFILE_FILE"
for VAR in "${VARS[@]}"; do
  ${SED_COMMAND} "/$VAR=/d" "$PROFILE_FILE"
  echo $VAR
done

# Clean up temp backup
rm -f "$PROFILE_FILE.bak"

# Check for jq
if ! command -v jq &> /dev/null; then
  echo "❌ 'jq' is required but not installed. Please install jq and try again."
  exit 1
fi

# Read values from file
ARM_CLIENT_ID=$(jq -r '.clientId' "$INPUT_FILE")
ARM_CLIENT_SECRET=$(jq -r '.clientSecret' "$INPUT_FILE")
ARM_SUBSCRIPTION_ID=$(jq -r '.subscriptionId' "$INPUT_FILE")
ARM_TENANT_ID=$(jq -r '.tenantId' "$INPUT_FILE")

if [[ -z "$ARM_CLIENT_ID" || -z "$ARM_CLIENT_SECRET" || -z "$ARM_SUBSCRIPTION_ID" || -z "$ARM_TENANT_ID" ]]; then
  echo "❌ Failed to extract credentials. Please check the JSON input."
  exit 1
fi
# Write to ~/.profile
{
  echo ""
  echo "# Azure credentials for Terraform"
  echo "ARM_CLIENT_ID=$ARM_CLIENT_ID"
  echo "ARM_CLIENT_SECRET=$ARM_CLIENT_SECRET"
  echo "ARM_SUBSCRIPTION_ID=$ARM_SUBSCRIPTION_ID"
  echo "ARM_TENANT_ID=$ARM_TENANT_ID"
} >> "$PROFILE_FILE"

echo "✅ Azure environment variables saved to $PROFILE_FILE"

# Reload profile
echo "🔄 Reloading profile..."
source "$PROFILE_FILE"

# Confirm
echo "🔍 Current values:"
echo "ARM_CLIENT_ID=$ARM_CLIENT_ID"
echo "ARM_SUBSCRIPTION_ID=$ARM_SUBSCRIPTION_ID"
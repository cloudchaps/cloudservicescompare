#!/bin/bash

AZURE_USER_GROUP="$1"
USER_UPN="$2"  # Example: someone@yourdomain.com

echo "Adding user '$USER_UPN' to group '$AZURE_USER_GROUP'..."

if [[ -z "$AZURE_USER_GROUP" || -z "$USER_UPN" ]]; then
  echo "Usage: $0 <azure-user-group-name> <user-upn/email>"
  exit 1
fi

# Get user object ID using az CLI
AZURE_USER_OBJECT_ID=$(az ad user show --id "$USER_UPN" --query id -o tsv 2>/dev/null)

if [[ -z "$AZURE_USER_OBJECT_ID" ]]; then
  echo "❌ Error: Could not find user with UPN '$USER_UPN'."
  exit 1
fi

# Add user to group
az ad group member add \
  --group "$AZURE_USER_GROUP" \
  --member-id "$AZURE_USER_OBJECT_ID"

# Check if user was added successfully
if [[ $? -ne 0 ]]; then
  echo "❌ Error: Failed to add user '$USER_UPN' to group '$AZURE_USER_GROUP'."
  exit 1
fi<

# Add role assigment to group
az role assignment create \
  --role "Reader" \
  --assignee-object-id "$AZURE_USER_OBJECT_ID" \
  --assignee-principal-type User \
  --scope "/subscriptions/$AZURE_SUBSCRIPTION_ID/resourceGroups/$AZURE_RESOURCE_GROUP"

echo "✅ User '$USER_UPN' with Object ID $AZURE_USER_OBJECT_ID added to group '$AZURE_USER_GROUP'."

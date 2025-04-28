#!/bin/bash

BUCKET="${1}"

# Get list of object versions and delete markers
echo "📋 Getting list of object versions..."
VERSIONS=$(aws s3api list-object-versions --bucket "$BUCKET")
aws s3api list-object-versions --bucket "$BUCKET" \
  --query='{Objects: Versions[].{Key:Key,VersionId:VersionId}}' \
  > delete.json

echo "📎 Getting Delete markers of object versions ..."
OBJECTS=$(echo "$VERSIONS" | jq '[.Versions[]?, .DeleteMarkers[]?] | map({Key: .Key, VersionId: .VersionId})')
aws s3api list-object-versions --bucket "$BUCKET" \
  --query='{Objects: DeleteMarkers[].{Key:Key,VersionId:VersionId}}' \
  > delete_markers.json

# Merge the two JSONs
echo "📝 Merging the two JSONs..."
jq -s '.[0].Objects + .[1].Objects | {Objects: .}' delete.json delete_markers.json > final_delete.json

echo "📋 Getting list of object versions and delete markers..."


if [ "$(echo "$OBJECTS" | jq 'length')" -gt 0 ]; then
  echo "🗑️ Deleting all objects and markers..."
  aws s3api delete-objects --bucket "$BUCKET" --delete "{\"Objects\": $OBJECTS}"
  echo "✅ Done!"
else
  echo "✅ No objects to delete."
fi
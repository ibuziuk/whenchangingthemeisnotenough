#!/bin/bash
set -e
CURRENT_DIR=$(pwd)
PLUGIN_META=$CURRENT_DIR/$1
PLUGIN_YAML=$CURRENT_DIR/$2

tar -czvf che-plugin-yaml.tar.gz --absolute-names ${PLUGIN_YAML} > /dev/null

PLUGIN_BINARY=che-plugin-yaml.tar.gz

PLUGIN_ID=$(yq r ${PLUGIN_META} id)
PLUGIN_VERSION=$(yq r ${PLUGIN_META} version)

# Start registry if not exist
REGISTRY=$(oc get svc --field-selector='metadata.name=che-plugin-registry' 2>&1)
if [[ "$REGISTRY" == "No resources found." ]]; then
  echo "Che Plugin Registry is not deployed"
  exit 1
fi

HOST=$(oc get routes --field-selector='metadata.name=che-plugin-registry'  -o=custom-columns=":.spec.host" | xargs)
BINARY_URL="http://$HOST/plugins/$PLUGIN_ID/$PLUGIN_VERSION/${PLUGIN_BINARY}"

yq w ${PLUGIN_META} url ${BINARY_URL} > /dev/null

# Detect pod
POD_NAME=$(oc get pods --output name | grep che-plugin-registry | awk -F "/" '{print $2}')
echo "Registry pod is: $POD_NAME"

# Create folder
oc exec $POD_NAME -- mkdir -p /var/www/html/plugins/$PLUGIN_ID/$PLUGIN_VERSION

# Upload binary
oc cp "${PLUGIN_BINARY}" $POD_NAME:/var/www/html/plugins/$PLUGIN_ID/$PLUGIN_VERSION/
oc cp "${PLUGIN_META}" $POD_NAME:/var/www/html/plugins/$PLUGIN_ID/$PLUGIN_VERSION/


# Print binary link
echo "Plugin hosted at: $BINARY_URL"

# Create & Upload meta.yaml
cat > meta.yaml <<EOF
id: $PLUGIN_ID
version: $PLUGIN_VERSION
type: $PLUGIN_TYPE_EXT
name: $PLUGIN_ID
title: $PLUGIN_ID
description: Automatically genarated description for $PLUGIN_ID
icon: https://www.eclipse.org/che/images/ico/16x16.png
url: $BINARY_URL
EOF

oc cp ./meta.yaml $POD_NAME:/var/www/html/plugins/$PLUGIN_ID/$PLUGIN_VERSION

# Print meta link
META_URL="http://$HOST/plugins/$PLUGIN_ID/$PLUGIN_VERSION/meta.yaml"

echo "Meta hosted at: $META_URL"
echo "Done."

#!/bin/bash
set -e
CURRENT_DIR=$(pwd)
PLUGIN_META=$CURRENT_DIR/$1
PLUGIN_YAML=$CURRENT_DIR/$2

tar -czvf che-plugin-yaml.tar.gz $2 > /dev/null

PLUGIN_BINARY=che-plugin-yaml.tar.gz

PLUGIN_ID=$(yq r ${PLUGIN_META} id)
PLUGIN_VERSION=$(yq r ${PLUGIN_META} version)
PLUGIN_DESCRIPTION=$(yq r ${PLUGIN_META} description)
PLUGIN_TYPE=$(yq r ${PLUGIN_META} type)
PLUGIN_NAME=$(yq r ${PLUGIN_META} name)

# Start registry if not exist
REGISTRY=$(oc get svc --field-selector='metadata.name=che-plugin-registry' 2>&1)
if [[ "$REGISTRY" == "No resources found." ]]; then
  echo "Che Plugin Registry is not deployed"
  exit 1
fi

HOST=$(oc get routes --field-selector='metadata.name=che-plugin-registry'  -o=custom-columns=":.spec.host" | xargs)
BINARY_URL="http://$HOST/plugins/$PLUGIN_ID/$PLUGIN_VERSION/${PLUGIN_BINARY}"

yq w ${PLUGIN_META} url ${BINARY_URL} > ./new-meta.yaml

rm meta.yaml
mv new-meta.yaml meta.yaml

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
oc cp ./meta.yaml $POD_NAME:/var/www/html/plugins/$PLUGIN_ID/$PLUGIN_VERSION

rm -rf /tmp/temp-che-plugin-registry
mkdir /tmp/temp-che-plugin-registry
oc cp $POD_NAME:/var/www/html/plugins/index.json /tmp/temp-che-plugin-registry/index.json

JSON="{\"id\": \"${PLUGIN_ID}\", \"name\":\"$PLUGIN_NAME\", \"version\": \"${PLUGIN_VERSION}\", \"description\": \"${PLUGIN_DESCRIPTION}\", \"type\": \"${PLUGIN_TYPE}\", \"links\": {\"self\":\"/plugins/$PLUGIN_ID/$PLUGIN_VERSION/meta.yaml\"}}"

jq -e ".[.| length] |= . + ${JSON}" /tmp/temp-che-plugin-registry/index.json > /tmp/temp-che-plugin-registry/new.json

oc cp /tmp/temp-che-plugin-registry/new.json $POD_NAME:/var/www/html/plugins/index.json
#
# Print meta link
META_URL="http://$HOST/plugins/$PLUGIN_ID/$PLUGIN_VERSION/meta.yaml"

echo "Meta hosted at: $META_URL"
echo "Done."

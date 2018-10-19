docker build -t eclipse/che-plugin-registry:local .

export PLUGIN_REGISTRY_IMAGE_TAG=local
export PLUGIN_REGISTRY_IMAGE="eclipse/che-plugin-registry"
export PLUGIN_REGISTRY_IMAGE_PULL_POLICY="IfNotPresent"

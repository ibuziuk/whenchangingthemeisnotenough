export OC_PUBLIC_HOSTNAME=172.17.0.1
export OC_PUBLIC_IP=172.17.0.1

export PLUGIN_REGISTRY_IMAGE_TAG=latest
export PLUGIN_REGISTRY_IMAGE="demo/che-plugin-registry"
export PLUGIN_REGISTRY_IMAGE_PULL_POLICY="IfNotPresent"

export CHE_WORKSPACE_PLUGIN__BROKER_PULL__POLICY="IfNotPresent"
export CHE_WORKSPACE_SIDECAR_IMAGE__PULL__POLICY="IfNotPresent"
export CHE_IMAGE_TAG="latest"
export CHE_IMAGE_REPO="demo/che-server"

ocp --run-ocp --deploy-che --deploy-che-plugin-registry --no-pull

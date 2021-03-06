### How to run Che on ocp on Docker host
Note:
- do we want to run multiuser Che?

- `<REPO LOCATION>/deploy/openshift/ocp.sh  --run-ocp --deploy-che   --deploy-che-plugin-registry --multiuser`

### Build Theia image
Note:
- build sometimes fails for some reason
- build is very long, but restarting preserves cached layers

Steps:
- `cd theia-build`
- `bash ./build.sh`

### How to run custom registry

- Build, pull and retag all needed images with `./prepareLocalEnv.sh`
- add ocp to path
- run OCP with Che deployed with 'run-ocp-with-che.sh'

### How to add plugin or editor to a local registry

- create folder with name equal to an ID of your plugin or editor: `mkdir my-cool-plugin`
- create folder with name equal to the version of your plugin or editor: `mkdir my-cool-plugin/0.0.1`
- create meta.yaml file in `my-cool-plugin/0.0.1` with `echo "" > my-cool-plugin/0.0.1/meta.yaml`
- put next fields to your meta.yaml:
 - id
 - version
 - url
- upload your meta.yaml to the registry: `oc cp ./my-cool-plugin/ $(oc get pods --selector="deploymentconfig=che-plugin-registry" --no-headers=true -o custom-columns=:metadata.name):/var/www/html/plugins/`

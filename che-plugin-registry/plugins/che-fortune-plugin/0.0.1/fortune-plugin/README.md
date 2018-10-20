# che-fortune-plugin

Example of a plugin requiring the `fortune` tool being installed.


# How to run manually


Run theia endpoint with fortune tool installed
```
$ docker run --rm -p 10000:10000 -v path-to-unpacked-plugins:/plugins -e THEIA_PLUGIN_ENDPOINT_PORT=10000 wsskeleton/fortune

```

so endpoint will be ws://172.17.0.2:10000 for that endpoint later


Run Theia image (in the command below it's a local image so name may be different)
assuming ip of endpoint is 172.17.0.2
```
$ docker run -p 3000:3000 -e THEIA_PLUGIN_ENDPOINT_ADDRESS_0=ws://172.17.0.2:10000 -e THEIA_PLUGIN_ENDPOINT_MAPPING_che_che_fortune_plugin=ws://172.17.0.2:10000 -v path-to-unpacked-plugins:/plugins -e THEIA_PLUGINS=local-dir:///plugins eclipse/che-theia:nightly
```

For mapping Env var, plugin's ID is computed in typescript with
```
  `${plugin.publisher}_${plugin.name}`.replace(/\W/g, '_');
```
(plugin is the entry of package.json file)

**Important**
Note: plug-ins need to be unpacked else main theia process will unpack `.theia` files only in the main container and endpoint container won't see that file

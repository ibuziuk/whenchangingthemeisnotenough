docker pull sleshchenko/s2i-minimal-notebook:demo
docker tag sleshchenko/s2i-minimal-notebook:demo demo/s2i-minimal-notebook

docker pull sleshchenko/che-server:demo
docker tag sleshchenko/che-server:demo demo/che-server

docker pull sleshchenko/che-theia:demo
docker tag sleshchenko/che-theia:demo demo/che-theia

docker pull wsskeleton/che-hello
docker tag wsskeleton/che-hello demo/che-hello

docker pull wsskeleton/che-machine-exec
docker tag wsskeleton/che-machine-exec demo/che-machine-exec

docker pull wsskeleton/fortune
docker tag wsskeleton/fortune demo/fortune

docker pull eclipse/che-plugin-broker:v0.2.0
docker pull wsskeleton/che-plugin-broker:theia-broker

docker build -t demo/che-plugin-registry che-plugin-registry/.

echo "Copying publish script to your path!!!!"
echo "Please type sudo credentials if needed"
CURRENT_DIR=$(pwd)
sudo ln -s $CURRENT_DIR/publish.sh /usr/bin/publish-che-plugin

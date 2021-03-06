docker pull sleshchenko/s2i-minimal-notebook:demo
docker tag sleshchenko/s2i-minimal-notebook:demo demo/s2i-jupyter

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

docker pull sleshchenko/che-editor-gwt-ide:demo
docker tag sleshchenko/che-editor-gwt-ide:demo demo/che-editor-gwt-ide

docker build -t demo/che-plugin-registry che-plugin-registry/.

if [ ! -f /usr/bin/publish-che-plugin ]; then
  CURRENT_DIR=$(pwd)

  echo "Copying publish script to your path!!!!"
  echo "Please type sudo credentials if needed"

  sudo ln -s $CURRENT_DIR/publish.sh /usr/bin/publish-che-plugin
fi

CURRENT_DIR=$(pwd)
sed -i -e "s|\[\[REPO_DIR\]\]|${CURRENT_DIR}|g" get-editor-template.sh

if [ ! -f /usr/bin/get-editor-template ]; then
  CURRENT_DIR=$(pwd)

  echo "Copying get-editor-template script to your path!!!!"
  echo "Please type sudo credentials if needed"

  sudo ln -s $CURRENT_DIR/get-editor-template.sh /usr/bin/get-editor-template
fi

alias uncnflutter="unset PUB_HOSTED_URL;unset FLUTTER_STORAGE_BASE_URL"
uncnflutter

cd event_bus_auto
dart pub publish
cd ..
cd event_bus_auto_codegen
dart pub publish
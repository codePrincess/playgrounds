OUTPUT="Travel.playgroundbook"

cp "$SRCROOT/TravelLog/ViewController.swift" "$OUTPUT/Contents/Sources"
cp "$SRCROOT/TravelLog/LogController.swift" "$OUTPUT/Contents/Sources"

cp "$CODESIGNING_FOLDER_PATH/Assets.car" "$OUTPUT/Contents/PrivateResources"
cp -r "$CODESIGNING_FOLDER_PATH/Base.lproj/Main.storyboardc" "$OUTPUT/Contents/PrivateResources"

<a href="https://flutter.dev/">
  <h1 align="center">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://storage.googleapis.com/cms-storage-bucket/6e19fee6b47b36ca613f.png">
      <img alt="Flutter" src="https://storage.googleapis.com/cms-storage-bucket/c823e53b3a1a7b0d36a9.png">
    </picture>
  </h1>
</a>

[![Flutter CI Status](https://flutter-dashboard.appspot.com/api/public/build-status-badge?repo=flutter)](https://flutter-dashboard.appspot.com/#/build?repo=flutter)
[![Discord badge][]][Discord instructions]
[![Twitter handle][]][Twitter badge]
[![codecov](https://codecov.io/gh/flutter/flutter/branch/master/graph/badge.svg?token=11yDrJU2M2)](https://codecov.io/gh/flutter/flutter)
[![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/5631/badge)](https://bestpractices.coreinfrastructure.org/projects/5631)
[![SLSA 1](https://slsa.dev/images/gh-badge-level1.svg)](https://slsa.dev)

Flutter is Google's SDK for crafting beautiful, fast user experiences for
mobile, web, and desktop from a single codebase. Flutter works with existing
code, is used by developers and organizations around the world, and is free and
open source.

## Documentation

* [Install Flutter](https://flutter.dev/get-started/)
* [Flutter documentation](https://docs.flutter.dev/)
* [Development wiki](./docs/README.md)
* [Contributing to Flutter](https://github.com/flutter/flutter/blob/main/CONTRIBUTING.md)

For announcements about new releases, follow the
[flutter-announce@googlegroups.com](https://groups.google.com/forum/#!forum/flutter-announce)
mailing list. Our documentation also tracks [breaking
changes](https://docs.flutter.dev/release/breaking-changes) across releases.

## Terms of service

The Flutter tool may occasionally download resources from Google servers. By
downloading or using the Flutter SDK, you agree to the Google Terms of Service:
https://policies.google.com/terms

For example, when installed from GitHub (as opposed to from a prepackaged
archive), the Flutter tool will download the Dart SDK from Google servers
immediately when first run, as it is used to execute the `flutter` tool itself.
This will also occur when Flutter is upgraded (e.g. by running the `flutter
upgrade` command).

## About Flutter

We think Flutter will help you create beautiful, fast apps, with a productive,
extensible and open development model, whether you're targeting iOS or Android,
web, Windows, macOS, Linux or embedding it as the UI toolkit for a platform of
your choice.

### Take a picture using the camera

Cookbook
Plugins
Take a picture using the camera
Many apps require working with the device's cameras to take photos and videos. Flutter provides the camera plugin for this purpose. The camera plugin provides tools to get a list of the available cameras, display a preview coming from a specific camera, and take photos or videos.

Note
The camera_android_camerax plugin, built on top of the CameraX Android library, improves image resolution with automatic selection of the resolution based on the device's capability. This plugin also helps deal with device quirks, defined as camera hardware that might not work as expected.

For more information, check out the Google I/O 2024 talk, Building picture perfect camera experiences in Flutter with CameraX.

This recipe demonstrates how to use the camera plugin to display a preview, take a photo, and display it using the following steps:

Add the required dependencies.
Get a list of the available cameras.
Create and initialize the CameraController.
Use a CameraPreview to display the camera's feed.
Take a picture with the CameraController.
Display the picture with an Image widget.
1. Add the required dependencies
#
To complete this recipe, you need to add three dependencies to your app:

camera
Provides tools to work with the cameras on the device.
path_provider
Finds the correct paths to store images.
path
Creates paths that work on any platform.
To add the packages as dependencies, run flutter pub add:

flutter pub add camera path_provider path
content_copy
Tip
For android, You must update minSdkVersion to 21 (or higher).

On iOS, the following lines must be added inside ios/Runner/Info.plist to the access the camera and microphone.

<key>NSCameraUsageDescription</key>
<string>Explanation on why the camera access is needed.</string>
<key>NSMicrophoneUsageDescription</key>
<string>Explanation on why the microphone access is needed.</string>
content_copy
2. Get a list of the available cameras
#
Next, get a list of available cameras using the camera plugin.

// Ensure that plugin services are initialized so that `availableCameras()`
// can be called before `runApp()`
WidgetsFlutterBinding.ensureInitialized();

// Obtain a list of the available cameras on the device.
final cameras = await availableCameras();

// Get a specific camera from the list of available cameras.
final firstCamera = cameras.first;
content_copy
3. Create and initialize the CameraController
#
Once you have a camera, use the following steps to create and initialize a CameraController. This process establishes a connection to the device's camera that allows you to control the camera and display a preview of the camera's feed.

Create a StatefulWidget with a companion State class.
Add a variable to the State class to store the CameraController.
Add a variable to the State class to store the Future returned from CameraController.initialize().
Create and initialize the controller in the initState() method.
Dispose of the controller in the dispose() method.
```
// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Fill this out in the next steps.
    return Container();
  }
}
```
content_copy
Warning
If you don't initialize the CameraController, you cannot use the camera to display a preview and take pictures.

4. Use a CameraPreview to display the camera's feed
#
Next, use the CameraPreview widget from the camera package to display a preview of the camera's feed.

Remember
You must wait until the controller has finished initializing before working with the camera. Therefore, you must wait for the _initializeControllerFuture(), created in the previous step, to complete before showing a CameraPreview.

Use a FutureBuilder for exactly this purpose.

// You must wait until the controller is initialized before displaying the
// camera preview. Use a FutureBuilder to display a loading spinner until the
// controller has finished initializing.
FutureBuilder<void>(
  future: _initializeControllerFuture,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      // If the Future is complete, display the preview.
      return CameraPreview(_controller);
    } else {
      // Otherwise, display a loading indicator.
      return const Center(child: CircularProgressIndicator());
    }
  },
)
content_copy
5. Take a picture with the CameraController
#
You can use the CameraController to take pictures using the takePicture() method, which returns an XFile, a cross-platform, simplified File abstraction. On both Android and IOS, the new image is stored in their respective cache directories, and the path to that location is returned in the XFile.

In this example, create a FloatingActionButton that takes a picture using the CameraController when a user taps on the button.

Taking a picture requires 2 steps:

Ensure that the camera is initialized.
Use the controller to take a picture and ensure that it returns a Future<XFile>.
It is good practice to wrap these operations in a try / catch block in order to handle any errors that might occur.

FloatingActionButton(
  // Provide an onPressed callback.
  onPressed: () async {
    // Take the Picture in a try / catch block. If anything goes wrong,
    // catch the error.
    try {
      // Ensure that the camera is initialized.
      await _initializeControllerFuture;

      // Attempt to take a picture and then get the location
      // where the image file is saved.
      final image = await _controller.takePicture();
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }
  },
  child: const Icon(Icons.camera_alt),
)
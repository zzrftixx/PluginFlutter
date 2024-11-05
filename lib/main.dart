import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_plugin_pubdev/widget/takepicture_screen.dart';

Future<void>> main() async {
  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: TakePictureScreen(
        // Pass the appropriate camera to the TakePictureScreen widget.
        camera: firstCamera,
      ),
    ),
  );

  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
}


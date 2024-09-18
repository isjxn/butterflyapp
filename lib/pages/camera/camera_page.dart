import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({
    super.key,
    required this.camera,
    required this.onPictureTaken, // Accept the callback
  });

  final CameraDescription camera;
  final Future<XFile> Function() onPictureTaken; // Callback to take the picture

  @override
  State<CameraPage> createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> {
  static CameraController? cameraController;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    cameraController = CameraController(widget.camera, ResolutionPreset.max);
    _initializeControllerFuture = cameraController!.initialize();
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(cameraController!);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        }
    );
  }
}

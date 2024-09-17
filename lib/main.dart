import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tagfalter_monitoring/firebase_options.dart';
import 'package:tagfalter_monitoring/pages/camera/camera_page.dart';
import 'package:tagfalter_monitoring/pages/home/home_page.dart';
import 'package:tagfalter_monitoring/pages/image/image_page.dart';
import 'package:tagfalter_monitoring/pages/search/search_page.dart'; // SearchPage will now include DataPage content
import 'package:tagfalter_monitoring/widgets/bottom_navigation_bar_widget.dart';
import 'package:tagfalter_monitoring/widgets/app_bar_widget.dart'; // Import the new AppBar widget

import 'pages/menu/menu_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  runApp(ButterflyApp(camera: firstCamera));
}

class ButterflyApp extends StatefulWidget {
  const ButterflyApp({super.key, required this.camera});

  final CameraDescription camera;

  @override
  State<ButterflyApp> createState() => ButterflyAppState();
}

class ButterflyAppState extends State<ButterflyApp> {
  int currentPageIndex = 0;
  String? capturedImagePath; // Variable to hold the captured image path

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Butterfly Demo",
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        extendBody: true,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (currentPageIndex == 4) {
              // If on the camera page, take the picture
              try {
                final image = await takePicture(); // Capture the image
                setState(() {
                  capturedImagePath = image.path; // Store the captured image path
                  currentPageIndex = 2; // Navigate to ImagePage
                });
              } catch (e) {
                // Handle the error (e.g., no camera permission or camera not ready)
                print(e);
              }
            } else {
              // Otherwise, navigate to the camera page
              setState(() {
                currentPageIndex = 4;
              });
            }
          },
          backgroundColor: const Color.fromARGB(255, 25, 98, 2),
          foregroundColor: Colors.black,
          shape: const CircleBorder(),
          child: const Icon(Icons.camera_alt),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        bottomNavigationBar: BottomNavigationBarWidget(
          currentPageIndex: currentPageIndex,
          onPageSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
        ),

        appBar: const AppBarWidget(),

        body: <Widget>[
          const HomePage(),
          const SearchPage(),
          ImagePage(imagePath: capturedImagePath), // Pass image path to ImagePage
          const MenuPage(),
          CameraPage(camera: widget.camera, onPictureTaken: takePicture),
        ][currentPageIndex],
      ),
    );
  }

  Future<XFile> takePicture() async {
    // Ensure the camera controller is initialized
    if (mounted) {
      final cameraController = CameraPageState.cameraController;
      if (cameraController != null && cameraController.value.isInitialized) {
        return await cameraController.takePicture();
      } else {
        throw Exception('Camera is not initialized');
      }
    }
    throw Exception('Widget is not mounted');
  }
}


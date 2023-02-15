import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart'
    show SystemChrome, SystemUiMode, rootBundle;
import 'package:flutter/material.dart';
import 'package:herble/change_picture.dart';
import 'package:image_picker/image_picker.dart';

List<CameraDescription> cameras = [];

class CameraScreen extends StatefulWidget {
  final int cum;
  const CameraScreen({super.key, required this.cum});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? controller;
  bool _isRearCameraSelected = true;
  bool _isCameraInitialized = false;

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = controller;
    // Instantiating the camera controller
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    // Dispose the previous controller
    await previousCameraController?.dispose();

    // Replace with the new controller
    if (mounted) {
      setState(() {
        controller = cameraController;
      });
    }

    // Update UI if controller updated
    cameraController.addListener(() {
      if (mounted) setState(() {});
    });

    // Initialize controller
    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      print('Error initializing camera: $e');
    }

    // Update the Boolean
    if (mounted) {
      setState(() {
        _isCameraInitialized = controller!.value.isInitialized;
      });
    }
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      onNewCameraSelected(cameras[0]);
    }).catchError((err) {
      print('Error: $err.code\nError Message: $err.message');
    });
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      // Free up memory when camera not active
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // Reinitialize the camera with same properties
      onNewCameraSelected(cameraController.description);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black87,
        toolbarHeight: 69,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.cancel_sharp),
        ),
        title: const Text("Photo"),
      ),
      body: Column(
        children: [
          Stack(children: [
            Column(
              children: [
                _isCameraInitialized
                    ? AspectRatio(
                        aspectRatio: 1 / controller!.value.aspectRatio,
                        child: controller!.buildPreview(),
                      )
                    : Container(),
              ],
            ),
            Positioned(
              top: 20,
              right: 20,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _isCameraInitialized = false;
                  });
                  onNewCameraSelected(
                    cameras[_isRearCameraSelected ? 0 : 1],
                  );
                  setState(() {
                    _isRearCameraSelected = !_isRearCameraSelected;
                  });
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(
                      Icons.circle,
                      color: Colors.black38,
                      size: 60,
                    ),
                    Icon(
                      _isRearCameraSelected
                          ? Icons.camera_front
                          : Icons.camera_rear,
                      color: Colors.white,
                      size: 30,
                    ),
                  ],
                ),
              ),
            ),
          ]),
          Expanded(
            child: Container(
              color: Colors.black87,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: InkWell(
                onTap: () async {
                  final CameraController? cameraController = controller;
                  if (cameraController!.value.isTakingPicture) {
                    // A capture is already pending, do nothing.
                    return;
                  }
                  try {
                    final path = (await controller!.takePicture()).path;
                    final imageData = await File(path).readAsBytes();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PicturePage(
                                pic: imageData,
                                cum: widget.cum,
                              )),
                    );
                  } on CameraException catch (e) {
                    print('Error occured while taking picture: $e');
                  }
                },
                child: Align(
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.center,
                    children: const [
                      Icon(Icons.circle, color: Colors.white38, size: 80),
                      Icon(Icons.circle, color: Colors.white, size: 60),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Uint8List?> takePictureBytes() async {
    final CameraController? cameraController = controller;
    if (cameraController!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }
    try {
      XFile file = await cameraController.takePicture();
      return await file.readAsBytes();
    } on CameraException catch (e) {
      print('Error occured while taking picture: $e');
      return null;
    }
  }
}

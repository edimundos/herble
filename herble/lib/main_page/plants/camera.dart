import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart' show SystemChrome, SystemUiMode;
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:async';
import 'package:herble/globals.dart' as globals;
import 'package:herble/main_page/plants/individual_plant/update_plant_basics.dart';

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
                    ? Stack(
                        children: [
                          Positioned(
                              left: (MediaQuery.of(context).size.width -
                                      (MediaQuery.of(context).size.width -
                                          10)) /
                                  2,
                              top: (MediaQuery.of(context).size.height -
                                      (MediaQuery.of(context).size.width -
                                          10)) /
                                  2,
                              child: ClipOval(
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width - 10,
                                  height:
                                      MediaQuery.of(context).size.width - 10,
                                ),
                              )),
                          AspectRatio(
                            aspectRatio: 1 / controller!.value.aspectRatio,
                            child: controller!.buildPreview(),
                          ),
                        ],
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
                          builder: (context) => UpdatePlantBasics(
                                pic: imageData,
                                plant: globals.currentPlant,
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

  Future<Uint8List> cropToCircle(Uint8List imageData, double radius) async {
    ui.Image image = await loadImage(imageData);
    var pictureRecorder = ui.PictureRecorder();
    var canvas = Canvas(pictureRecorder);
    var paint = Paint();
    paint.isAntiAlias = true;

    final center = Offset(radius, radius);
    final paintCircle = Paint()..color = Colors.black;
    final paintBorder = Paint()
      ..color = Colors.white
      ..strokeWidth = radius / 18
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, paintCircle);
    canvas.drawCircle(center, radius, paintBorder);

    Path path = Path()
      ..addOval(Rect.fromLTWH(
          0, 0, image.width.toDouble() - 10, image.width.toDouble() - 10));
    //Rect.fromLTWH(0, 0, 150, 150));

    canvas.clipPath(path);

    canvas.drawImage(image, Offset(0, 0), Paint());
    var pic = pictureRecorder.endRecording();
    ui.Image img = await pic.toImage(image.width, image.height);
    var byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<ui.Image> loadImage(Uint8List img) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }
}

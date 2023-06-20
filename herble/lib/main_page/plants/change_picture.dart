import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:herble/main_page/plants/add_plant/add_plant.dart';
import 'package:herble/globals.dart' as globals;
import 'package:herble/main_page/plants/camera.dart';
import 'package:herble/main_page/plants/individual_plant/update_plant_basics.dart';
import 'package:image_picker/image_picker.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error in fetching the cameras: $e');
  }
  runApp(const PicturePage(
    pic: null,
    cum: 0,
  ));
}

class PicturePage extends StatefulWidget {
  final Uint8List? pic;
  final int cum;

  const PicturePage({Key? key, required this.pic, required this.cum})
      : super(key: key);

  @override
  State<PicturePage> createState() => _PicturePageState();
}

class _PicturePageState extends State<PicturePage> {
  late Uint8List pic;

  @override
  void initState() {
    super.initState();
    loadImageFromAssets('assets/default_plant-1.jpg').then((value) {
      setState(() {
        pic = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PicForm(pic: widget.pic, cum: widget.cum),
    );
  }

  Future<Uint8List> loadImageFromAssets(String url) async {
    final byteData = await rootBundle.load(url);
    return byteData.buffer.asUint8List();
  }
}

class PicForm extends StatefulWidget {
  final Uint8List? pic;
  final int cum;

  const PicForm({Key? key, required this.pic, required this.cum})
      : super(key: key);

  @override
  State<PicForm> createState() => _PicFormState();
}

class _PicFormState extends State<PicForm> {
  late Uint8List? currentPicture;
  int? picId;

  @override
  void initState() {
    super.initState();
    if (widget.pic != null) {
      currentPicture = widget.pic!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
              height: 100,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: GestureDetector(
                        onTap: () {
                          if (widget.cum == 2) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UpdatePlantBasics(
                                        pic: widget.pic!,
                                        plant: globals.currentPlant,
                                      )),
                            );
                          }
                          if (widget.cum == 1) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddPlantPage(
                                        pic: widget.pic!,
                                      )),
                            );
                          }
                        },
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Image(
                              image: AssetImage("assets/backButton.png"),
                            ),
                          ),
                        )),
                  ),
                  Text(
                    "Change picture",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      height: 1,
                      color: const Color.fromARGB(255, 32, 54, 50),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Spacer(),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.all(25.0),
                      child: Image(
                        image: AssetImage("assets/herble_logo.png"),
                      ),
                    ),
                  )
                ],
              )),
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    border: Border.all(
                      color: Colors.black45,
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    clipBehavior: Clip.hardEdge,
                    borderRadius: BorderRadius.circular(35),
                    child: currentPicture == null
                        ? const FittedBox(
                            fit: BoxFit.cover,
                            child: Image(
                              image: AssetImage('assets/default_plant-1.jpg'),
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.memory(
                            currentPicture!,
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    Text(
                      "Choose from default pictures",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        height: 1,
                        color: const Color.fromARGB(255, 32, 54, 50),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Row(children: [
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () async {
                            Uint8List newPicture = await loadImageFromAssets(
                                'assets/default_plant0.jpg');
                            setState(() {
                              currentPicture = newPicture;
                            });
                            picId = 0;
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35),
                              border: Border.all(
                                color: Colors.black26,
                                width: 2,
                              ),
                            ),
                            child: ClipRRect(
                              clipBehavior: Clip.hardEdge,
                              borderRadius: BorderRadius.circular(35),
                              child: Image.asset(
                                'assets/default_plant0.jpg',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () async {
                            Uint8List newPicture = await loadImageFromAssets(
                                'assets/default_plant1.jpg');
                            setState(() {
                              currentPicture = newPicture;
                            });
                            picId = 1;
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35),
                              border: Border.all(
                                color: Colors.black26,
                                width: 2,
                              ),
                            ),
                            child: ClipRRect(
                              clipBehavior: Clip.hardEdge,
                              borderRadius: BorderRadius.circular(35),
                              child: Image.asset(
                                'assets/default_plant1.jpg',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () async {
                            Uint8List newPicture = await loadImageFromAssets(
                                'assets/default_plant2.jpg');
                            setState(() {
                              currentPicture = newPicture;
                            });
                            picId = 2;
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35),
                              border: Border.all(
                                color: Colors.black26,
                                width: 2,
                              ),
                            ),
                            child: ClipRRect(
                              clipBehavior: Clip.hardEdge,
                              borderRadius: BorderRadius.circular(35),
                              child: Image.asset(
                                'assets/default_plant2.jpg',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Row(children: [
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () async {
                            Uint8List newPicture = await loadImageFromAssets(
                                'assets/default_plant3.jpg');
                            setState(() {
                              currentPicture = newPicture;
                            });
                            picId = 3;
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35),
                              border: Border.all(
                                color: Colors.black26,
                                width: 2,
                              ),
                            ),
                            child: ClipRRect(
                              clipBehavior: Clip.hardEdge,
                              borderRadius: BorderRadius.circular(35),
                              child: Image.asset(
                                'assets/default_plant3.jpg',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () async {
                            Uint8List newPicture = await loadImageFromAssets(
                                'assets/default_plant4.jpg');
                            setState(() {
                              currentPicture = newPicture;
                            });
                            picId = 4;
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35),
                              border: Border.all(
                                color: Colors.black26,
                                width: 2,
                              ),
                            ),
                            child: ClipRRect(
                              clipBehavior: Clip.hardEdge,
                              borderRadius: BorderRadius.circular(35),
                              child: Image.asset(
                                'assets/default_plant4.jpg',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () async {
                            Uint8List newPicture = await loadImageFromAssets(
                                'assets/default_plant5.jpg');
                            setState(() {
                              currentPicture = newPicture;
                            });
                            picId = 5;
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35),
                              border: Border.all(
                                color: Colors.black26,
                                width: 2,
                              ),
                            ),
                            child: ClipRRect(
                              clipBehavior: Clip.hardEdge,
                              borderRadius: BorderRadius.circular(35),
                              child: Image.asset(
                                'assets/default_plant5.jpg',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  // ignore: sort_child_properties_last
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Choose from gallery",
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          height: 1,
                          color: Color.fromARGB(255, 255, 255, 255),
                        )),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 177, 177, 177),
                    elevation: 0,
                  ),
                  onPressed: _useGalery,
                ),
                ElevatedButton(
                  // ignore: sort_child_properties_last
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Open camera",
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          height: 1,
                          color: Color.fromARGB(255, 255, 255, 255),
                        )),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 177, 177, 177),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CameraScreen(cum: widget.cum)),
                    );
                    picId = null;
                  },
                ),
                ElevatedButton(
                  // ignore: sort_child_properties_last
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Save image",
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          height: 1,
                          color: Color.fromARGB(255, 255, 255, 255),
                        )),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 177, 177, 177),
                    elevation: 0,
                  ),
                  onPressed: () {
                    if (widget.cum == 1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddPlantPage(
                                  pic: currentPicture!,
                                  picId: picId,
                                )),
                      );
                    } else if (widget.cum == 2) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdatePlantBasics(
                                  pic: currentPicture!,
                                  plant: globals.currentPlant,
                                  picId: picId,
                                )),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<Uint8List> loadImageFromAssets(String url) async {
    final byteData = await rootBundle.load(url);
    return byteData.buffer.asUint8List();
  }

  Future<void> _useGalery() async {
    var imagePicker = ImagePicker();
    picId = null;
    var image = await imagePicker.pickImage(source: ImageSource.gallery);
    Uint8List bytes = await image!.readAsBytes();
    setState(() {
      currentPicture = bytes;
    });
  }
}

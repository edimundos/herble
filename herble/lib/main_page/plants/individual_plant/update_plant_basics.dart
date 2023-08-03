import 'dart:convert';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:herble/main_page/plants/change_picture.dart';
import 'package:herble/main_page/plants/individual_plant/individual_plant.dart';
import 'package:herble/main_page/main_page.dart';
import 'package:http/http.dart' as http;
import 'package:herble/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../add_plant/add_plant.dart';
import '../camera.dart';

List<CameraDescription> cameras = [];

class UpdatePlantBasics extends StatefulWidget {
  final globals.Plant plant;
  final Uint8List pic;
  final int? picId;

  const UpdatePlantBasics(
      {Key? key, required this.plant, required this.pic, this.picId})
      : super(key: key);

  @override
  State<UpdatePlantBasics> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePlantBasics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PlantUpdateForm(
      plant: widget.plant,
      pic: widget.pic,
      picId: widget.picId,
      cum: 0,
    ));
  }
}

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

class PlantUpdateForm extends StatefulWidget {
  final globals.Plant plant;
  final Uint8List pic;
  final int? picId;
  final int cum;

  const PlantUpdateForm(
      {Key? key,
      required this.plant,
      required this.pic,
      required this.picId,
      required this.cum})
      : super(key: key);

  @override
  State<PlantUpdateForm> createState() => _PlantUpdateFormState();
}

class _PlantUpdateFormState extends State<PlantUpdateForm> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final dayController = TextEditingController();
  final volumeController = TextEditingController();
  late Uint8List? currentPicture;
  int? picId;

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    dayController.dispose();
    volumeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    nameController.text = widget.plant.plantName;
    descriptionController.text = widget.plant.plantDescription;
    dayController.text = widget.plant.dayCount.toString();
    volumeController.text = widget.plant.waterVolume.toString();
    // if (widget.pic != null) {
    //   currentPicture = widget.pic!;
    // }
    super.initState();
  }

  bool isPhotoSelected = true; // Initially, a photo is assumed to be selected.

  String characterCountText = '0 / 200'; // Initialize with default values
  Color characterCountColor = Colors.grey; // Initialize with default color

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        reverse: true,
        child: Column(
          children: [
            SizedBox(
                height: 100,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Material(
                        shape: const CircleBorder(),
                        clipBehavior: Clip.hardEdge,
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => IndividualPlant(
                                  plant: globals.currentPlant,
                                  pic: widget.pic,
                                ),
                              ),
                            );
                          },
                          icon: Icon(Icons.arrow_back_sharp,
                              size: globals.width * 0.03,
                              color: Colors.black38),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Update basics",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 25,
                          // fontWeight: FontWeight.bold,
                          height: 1,
                          color: const Color.fromARGB(255, 32, 54, 50),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 30, 3, 30),
                      child: ElevatedButton(
                        // ignore: sort_child_properties_last

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding:
                              EdgeInsets.symmetric(vertical: 1, horizontal: 1),
                          elevation: 0,
                        ),
                        onPressed: () async {
                          int validator = dataIsValid(
                            nameController.text,
                            descriptionController.text,
                            dayController.text,
                            volumeController.text,
                          );
                          if (validator == 100 && globals.isLoggedIn) {
                            await updatePlant(
                              nameController.text,
                              descriptionController.text,
                              int.parse(dayController.text),
                              widget.pic,
                              int.parse(volumeController.text),
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainPage(index: 1)),
                            );
                          } else if (validator == 103) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content:
                                      const Text('Day count must be a number'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Ok'),
                                      child: const Text('Ok'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else if (validator == 104) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: const Text(
                                      'Water volume must be a number'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Ok'),
                                      child: const Text('Ok'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else if (validator == 105) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content:
                                      const Text('Plant name cannot be empty'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Ok'),
                                      child: const Text('Ok'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else if (validator == 106) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content:
                                      const Text('Day count cannot be empty'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Ok'),
                                      child: const Text('Ok'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else if (validator == 107) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: const Text(
                                      'Water volume cannot be empty'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Ok'),
                                      child: const Text('Ok'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            () {
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
                            };
                          }
                        },
                        // ignore: sort_child_properties_last

                        child: Center(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: SizedBox(
                                child: Text(
                                  'Save',
                                  style: GoogleFonts.inter(
                                    fontSize: globals.width * 0.017,
                                    fontWeight: FontWeight.w400,
                                    height: 1,
                                    color:
                                        const Color.fromARGB(255, 31, 100, 58),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor:
                      Colors.transparent, // Set transparent background
                  builder: (BuildContext context) {
                    return Container(
                      color: Colors
                          .white, // Set the background color of the bottom sheet content
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.photo_library),
                            title: const Text('Choose from Gallery'),
                            onTap: () {
                              _useGalery();
                              // Navigator.pop(context); // Close the bottom sheet
                              // Add your code for handling the "Choose from Gallery" option here
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.camera_alt),
                            title: const Text('Take Photo'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CameraScreen(cum: widget.cum)),
                              );
                              picId = null; // Close the bottom sheet
                              // Add your code for handling the "Take Photo" option here
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.palette),
                            title: const Text('Choose from Presets'),
                            onTap: () {
                              Navigator.pop(context); // Close the bottom sheet
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PicturePage(pic: widget.pic, cum: 2)),
                              );
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.delete),
                            title: const Text('Remove Current Photo'),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: ClipRRect(
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(35),
                child: Stack(
                  children: [
                    Image.memory(
                      widget.pic,
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.cover,
                    ),
                    const Positioned(
                      bottom: 10,
                      right: 10,
                      child: Icon(
                        Icons.edit,
                        color: Colors.black45,
                        size: 40.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // GestureDetector(
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) =>
            //               PicturePage(pic: widget.pic, cum: 2)),
            //     );
            //   },
            //   child: ClipRRect(
            //     clipBehavior: Clip.hardEdge,
            //     borderRadius: BorderRadius.circular(35),
            //     child: Stack(
            //       children: [
            //         Image.memory(
            //           widget.pic,
            //           width: 200.0,
            //           height: 200.0,
            //           fit: BoxFit.cover,
            //         ),
            //         const Positioned(
            //           bottom: 10,
            //           right: 10,
            //           child: Icon(
            //             Icons.edit,
            //             color: Colors.black45,
            //             size: 40.0,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    onChanged: (value) {
                      // Limit the character count to 15
                      if (value.length > 15) {
                        nameController.text = value.substring(0, 15);
                        nameController.selection = TextSelection.fromPosition(
                            TextPosition(offset: nameController.text.length));
                      }

                      // Update the character count when the text changes
                      int currentCharacters = nameController.text.length;
                      int maxCharacters =
                          15; // Set your maximum character limit here
                      setState(() {
                        characterCountText =
                            '$currentCharacters / $maxCharacters';
                        // Check if the character limit is exceeded and update the color accordingly
                        characterCountColor = currentCharacters <= maxCharacters
                            ? Colors.grey
                            : Colors.red;
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Plant name',
                    ),
                    validator: validateName,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Characters used: ${nameController.text.length} / 15',
                    style: TextStyle(
                      fontSize: 14,
                      color: nameController.text.length <= 14
                          ? Colors.grey
                          : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: descriptionController,
                      onChanged: (value) {
                        // Limit the character count to 200
                        if (value.length > 200) {
                          descriptionController.text = value.substring(0, 200);
                          descriptionController.selection =
                              TextSelection.fromPosition(TextPosition(
                                  offset: descriptionController.text.length));
                        }

                        // Update the character count when the text changes
                        int currentCharacters =
                            descriptionController.text.length;
                        int maxCharacters =
                            200; // Set your maximum character limit here
                        setState(() {
                          characterCountText =
                              '$currentCharacters / $maxCharacters';
                          // Check if the character limit is exceeded and update the color accordingly
                          characterCountColor =
                              currentCharacters <= maxCharacters
                                  ? Colors.grey
                                  : Colors.red;
                        });
                      },
                      maxLines:
                          null, // Set maxLines to null to enable multiline input
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Description',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Characters used: ${descriptionController.text.length} / 200',
                      style: TextStyle(
                        fontSize: 14,
                        color: descriptionController.text.length <= 199
                            ? Colors.grey
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updatePlant(
      String name, String desc, int days, Uint8List pic, int volume) async {
    String url = 'https://herbledb.000webhostapp.com/update_plant.php';
    String picture;
    if (widget.picId != null) {
      picture = widget.picId.toString();
    } else {
      picture = base64Encode(pic).toString();
    }
    await http.post(Uri.parse(url), body: {
      'id': widget.plant.plantId.toString(),
      'plant_name': name,
      'plant_description': desc,
      'day_count': days.toString(),
      'picture': picture,
      'water_volume': volume.toString(),
    });
  }

  String? validateName(String? value) {
    if (value!.length < 3) {
      return 'Name must be more than 2 charaters';
    }
    if (value.length > 250) {
      return 'Name cant be more than 250 characters';
    } else {
      return null;
    }
  }

  int dataIsValid(String species, String desc, String days, String volume) {
    if (species.isEmpty) return 105;
    if (days.isEmpty) return 106;
    if (volume.isEmpty) return 107;
    if (species.length > 250) return 101;
    if (desc.length > 2000) return 102;
    if (int.tryParse(days) == null) return 103;
    if (int.tryParse(volume) == null) return 104;
    return 100;
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

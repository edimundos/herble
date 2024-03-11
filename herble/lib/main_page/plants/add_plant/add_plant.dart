import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:herble/colors.dart';
import 'package:herble/main_page/plants/change_picture.dart';
import 'package:herble/main_page/plants/add_plant/connect_to_internet_page.dart';
import 'package:herble/main_page/main_page.dart';
import 'package:http/http.dart' as http;
import '../../../globals.dart' as globals;
import 'package:google_fonts/google_fonts.dart';

class AddPlantPage extends StatefulWidget {
  final Uint8List pic;
  final int? picId;

  const AddPlantPage({Key? key, required this.pic, this.picId})
      : super(key: key);

  @override
  State<AddPlantPage> createState() => _AddPlantPageState();
}

class _AddPlantPageState extends State<AddPlantPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PlantForm(pic: widget.pic, picId: widget.picId),
    );
  }
}

class PlantForm extends StatefulWidget {
  final Uint8List pic;
  final int? picId;

  const PlantForm({super.key, required this.pic, this.picId});

  @override
  State<PlantForm> createState() => _PlantFormState();
}

String characterCountText = '0 / 200'; // Initialize with default values
Color characterCountColor = Colors.grey; // Initialize with default color
Color enabledButtonColor = mainpallete;
Color disabledButtonColor = Colors.grey;

class _PlantFormState extends State<PlantForm> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final dayController = TextEditingController();
  final volumeController = TextEditingController();
  Color buttonColor = enabledButtonColor;

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    dayController.dispose();
    volumeController.dispose();
    super.dispose();
  }

  bool isAnyTextFieldEmpty() {
    return nameController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        dayController.text.isEmpty ||
        volumeController.text.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              "Add Plant",
              textAlign: TextAlign.left,
              style: GoogleFonts.inter(color: Colors.black),
            ),
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MainPage(
                            index: 1,
                          )),
                );
              },
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
            ),
            actions: [
              Image(
                image: const AssetImage("assets/herble_logo.png"),
                width: MediaQuery.of(context).size.width * 0.1,
              ),
            ]),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Column(
              children: [
                SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    reverse: true,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PicturePage(pic: widget.pic, cum: 1)),
                            );
                          },
                          child: Container(
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
                              child: Image.memory(
                                widget.pic,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 16),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: nameController,
                                onChanged: (value) {
                                  // Limit the character count to 15
                                  if (value.length > 15) {
                                    nameController.text =
                                        value.substring(0, 15);
                                    nameController.selection =
                                        TextSelection.fromPosition(TextPosition(
                                            offset:
                                                nameController.text.length));
                                  }

                                  // Update the character count when the text changes
                                  int currentCharacters =
                                      nameController.text.length;
                                  int maxCharacters =
                                      15; // Set your maximum character limit here
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
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: nameController.text.length > 2
                                          ? Colors.grey
                                          : Colors.red,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: nameController.text.length > 2
                                          ? Colors.grey
                                          : Colors.red,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: nameController.text.length > 2
                                          ? mainpallete
                                          : Colors.red,
                                      width: 2.0,
                                    ),
                                  ),
                                  labelText: 'Plant name',
                                  labelStyle: TextStyle(
                                    color: nameController.text.length < 3
                                        ? Colors.red
                                        : null,
                                  ),
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 16),
                          child: Column(
                            children: [
                              TextField(
                                controller: descriptionController,
                                onChanged: (value) {
                                  // Limit the character count to 200
                                  if (value.length > 200) {
                                    descriptionController.text =
                                        value.substring(0, 200);
                                    descriptionController.selection =
                                        TextSelection.fromPosition(
                                      TextPosition(
                                          offset: descriptionController
                                              .text.length),
                                    );
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
                                  color:
                                      descriptionController.text.length <= 199
                                          ? Colors.grey
                                          : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 0),
                          child: Row(
                            children: [
                              Text(
                                "Watering frequency: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text("Water every "),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.11,
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  controller: dayController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: dayController.text.isEmpty ||
                                                int.tryParse(
                                                        dayController.text)! <=
                                                    0 ||
                                                int.tryParse(
                                                        dayController.text)! >=
                                                    100
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: dayController.text.isEmpty ||
                                                int.tryParse(
                                                        dayController.text)! <=
                                                    0 ||
                                                int.tryParse(
                                                        dayController.text)! >=
                                                    100
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: dayController.text.isEmpty ||
                                                int.tryParse(
                                                        dayController.text)! <=
                                                    0 ||
                                                int.tryParse(
                                                        dayController.text)! >=
                                                    100
                                            ? Colors.red
                                            : mainpallete,
                                      ),
                                    ),
                                    labelText: '',
                                  ),
                                  onChanged: (value) {
                                    setState(
                                        () {}); // Force a rebuild to update border colors
                                  },
                                  onEditingComplete: () {
                                    setState(
                                        () {}); // Force a rebuild to update border colors when editing is complete
                                  },
                                ),
                              ),
                              Text(" day/days"),
                            ],
                          ),
                        ),
                        Padding(
                          //te ganjau vajadzes kaut kādu check box ar dazadiem variantiem or smth un tad pedejais variants "Custom:"
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 16),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: volumeController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: volumeController.text.isEmpty ||
                                          (int.tryParse(
                                                  volumeController.text))! <=
                                              0 ||
                                          int.tryParse(
                                                  volumeController.text)! >=
                                              1050
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: volumeController.text.isEmpty ||
                                          (int.tryParse(
                                                  volumeController.text))! <=
                                              0 ||
                                          int.tryParse(
                                                  volumeController.text)! >=
                                              1050
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: volumeController.text.isEmpty ||
                                          (int.tryParse(
                                                  volumeController.text))! <=
                                              0 ||
                                          int.tryParse(
                                                  volumeController.text)! >=
                                              1050
                                      ? Colors.red
                                      : mainpallete,
                                ),
                              ),
                              labelText: 'Water volume',
                            ),
                            onChanged: (value) {
                              setState(
                                  () {}); // Force a rebuild to update border colors
                            },
                            onEditingComplete: () {
                              setState(
                                  () {}); // Force a rebuild to update border colors when editing is complete
                            },
                          ),
                        ),
                        ElevatedButton(
                          onPressed: isAnyTextFieldEmpty()
                              ? null
                              : () async {
                                  int validator = await dataIsValid(
                                    nameController.text,
                                    descriptionController.text,
                                    dayController.text,
                                    volumeController.text,
                                  );
                                  print(validator);
                                  print(globals.isLoggedIn);
                                  if (validator == 100 &&
                                      globals.isLoggedIn &&
                                      !isAnyTextFieldEmpty()) {
                                    sendToChip(
                                      int.parse(dayController.text),
                                      int.parse(volumeController.text),
                                    );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ConnectInternet(
                                                plant: nameController.text,
                                                desc:
                                                    descriptionController.text,
                                                days: int.parse(
                                                    dayController.text),
                                                pic: base64Encode(widget.pic),
                                                picId: widget.picId,
                                                volume: int.parse(
                                                    volumeController.text),
                                              )),
                                    );
                                  } else if (validator == 105) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: const Text(
                                              'Plant name cant be empty'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                  context, 'sorry'),
                                              child: const Text('sorry'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else if (validator == 108) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: const Text(
                                              'Must be connected to plant pot'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                  context, 'sorry'),
                                              child: const Text('sorry'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else if (validator == 109) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: const Text(
                                              'This pot cannot hold more than 1050ml'),
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
                                  }

                                  setState(() {
                                    buttonColor = isAnyTextFieldEmpty()
                                        ? disabledButtonColor
                                        : enabledButtonColor;
                                  });
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                buttonColor, // Use the button color defined based on text field emptiness
                          ),
                          child: const Text('Confirm'),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ));
  }

  Future<int> dataIsValid(
      String species, String desc, String days, String volume) async {
    if (species.isEmpty) return 105;
    if (days.isEmpty) return 106;
    if (volume.isEmpty) return 107;
    if (int.tryParse(days) == null) return 103;
    if (int.tryParse(volume) == null) return 104;
    if (!await checkIfUrlIsAccessible()) return 108;
    if (int.parse(volume) > 1050) return 109;
    return 100;
  }

  Future<void> sendToChip(int days, int volume) async {
    String url = 'http://192.168.4.1/?var1=$days&var2=$volume';
    await http.post(Uri.parse(url));
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

  Future<bool> checkIfUrlIsAccessible() async {
    try {
      final response = await Future.any([
        http.get(Uri.parse("http://192.168.4.1/")),
        Future.delayed(const Duration(seconds: 3), () => null),
      ]);
      if (response == null) {
        throw Exception("Request timed out");
      }
      if (response.statusCode == 200) {
        return true;
      }
    } catch (_) {
      return false;
    }
    return false;
  }
}

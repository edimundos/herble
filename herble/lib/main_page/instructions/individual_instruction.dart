import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../globals.dart' as globals;
import '../main_page.dart';

class IndividualInstruction extends StatefulWidget {
  final globals.Instruction instruction;
  const IndividualInstruction({super.key, required this.instruction});

  @override
  State<IndividualInstruction> createState() => _IndividualInstructionState();
}

class _IndividualInstructionState extends State<IndividualInstruction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
              height: globals.height * 0.038,
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
                              builder: (BuildContext context) {
                                return const MainPage(); // Replace ChangeSettings with the actual widget for the settings page
                              },
                            ),
                          );
                        },
                        icon: Icon(Icons.arrow_back_sharp,
                            size: globals.width * 0.03, color: Colors.black26),
                      ),
                    ),
                  ),
                  // const SizedBox(
                  //   width: 40,
                  // ),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: Text(
              widget.instruction.question,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: globals.height * 0.013,
                fontWeight: FontWeight.bold,
                height: 1,
                color: const Color.fromARGB(255, 32, 54, 50),
              ),
            ),
          ),
          SizedBox(height: globals.height * 0.01),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
            child: Text(
              widget.instruction.answer,
              style: GoogleFonts.inter(
                fontSize: globals.height * 0.008,
                fontWeight: FontWeight.normal,
                height: 1,
                color: const Color.fromARGB(255, 32, 54, 50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

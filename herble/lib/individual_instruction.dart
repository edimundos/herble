import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'globals.dart' as globals;
import 'main_page.dart';

class IndividualInstruction extends StatefulWidget {
  globals.Instruction instruction;
  IndividualInstruction({super.key, required this.instruction});

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
              height: 100,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainPage(
                                      index: 0,
                                    )),
                          );
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
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
            child: Text(
              widget.instruction.question,
              textAlign: TextAlign.center,
              style: GoogleFonts.cormorantGaramond(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                height: 1,
                color: const Color.fromARGB(255, 32, 54, 50),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
            child: Text(
              widget.instruction.answer,
              style: GoogleFonts.cormorantGaramond(
                fontSize: 20,
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

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:herble/main_page/instructions/individual_instruction.dart';
import '../../globals.dart' as globals;

class Instructions extends StatefulWidget {
  const Instructions({super.key});

  @override
  State<Instructions> createState() => _InstructionsState();
}

class _InstructionsState extends State<Instructions> {
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      body: const InstructionsForm(),
    );
  }
}

class InstructionsForm extends StatefulWidget {
  const InstructionsForm({super.key});

  @override
  State<InstructionsForm> createState() => _InstructionsFormState();
}

class _InstructionsFormState extends State<InstructionsForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
              height: globals.height * 0.04,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      "Instructions",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.caudex(
                        fontSize: globals.width * 0.03,
                        // fontWeight: FontWeight.bold,
                        height: 1,
                        color: const Color.fromARGB(255, 32, 54, 50),
                      ),
                    ),
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
          Expanded(
            child: ListView.builder(
              itemCount: globals.allInstructions!.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IndividualInstruction(
                          instruction: globals.allInstructions![index],
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color.fromARGB(255, 240, 240, 240)),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5.0),
                          child: Text(
                            globals.allInstructions![index].question,
                            style: GoogleFonts.inter(
                              fontSize: globals.width * 0.018,
                              fontWeight: FontWeight.bold,
                              height: 1,
                              color: const Color.fromARGB(255, 32, 54, 50),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

/// ##################################################
class _InstructionsFormState extends State<InstructionsForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Instructions",
          textAlign: TextAlign.center,
          style: GoogleFonts.caudex(
            color: const Color.fromARGB(255, 32, 54, 50),
            fontSize: MediaQuery.of(context).size.width * 0.08,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          Builder(
            builder: (context) {
              double availableWidth = MediaQuery.of(context).size.width;
              double desiredSize =
                  availableWidth * 0.1; // 10% of available width
              return Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Image(
                  image: AssetImage("assets/herble_logo.png"),
                  width: desiredSize,
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: globals.allInstructions!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color.fromARGB(255, 240, 240, 240),
                      ),
                      child: ExpansionTile(
                        title: Text(
                          globals.allInstructions![index].question,
                          textAlign: TextAlign.left,
                          style: GoogleFonts.inter(
                            fontSize: globals.width * 0.018,
                            fontWeight: FontWeight.w600,
                            height: 1,
                            color: const Color.fromARGB(255, 32, 54, 50),
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                15.0, 5.0, 15.0, 10.0),
                            child: Text(
                              globals.allInstructions![index].answer,
                              style: TextStyle(
                                fontSize: globals.width * 0.016,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.email_outlined, size: 50),
                  Text(
                    "Did not see your question here?",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 17,
                      // fontWeight: FontWeight.bold,
                      height: 1,
                      color: const Color.fromARGB(255, 32, 54, 50),
                    ),
                  ),
                  Text(
                    "Send us an email to ",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 17,
                      // fontWeight: FontWeight.bold,
                      height: 1,
                      color: const Color.fromARGB(255, 32, 54, 50),
                    ),
                  ),
                  Text(
                    "info@herble.eu ",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1,
                      color: const Color.fromARGB(255, 32, 54, 50),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

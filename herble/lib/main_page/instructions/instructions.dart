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
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: globals.height * 0.004),
          SizedBox(
              height: globals.height * 0.04,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
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
                          padding:
                              const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 10.0),
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
    );
  }
}

// ######################################### try to get "" in the database maybe?

// class _InstructionsFormState extends State<InstructionsForm> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           SizedBox(
//             height: globals.height * 0.04,
//             child: Row(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: 20.0),
//                   child: Text(
//                     "Instructions",
//                     textAlign: TextAlign.left,
//                     style: GoogleFonts.caudex(
//                       fontSize: globals.width * 0.03,
//                       height: 1,
//                       color: const Color.fromARGB(255, 32, 54, 50),
//                     ),
//                   ),
//                 ),
//                 const Spacer(),
//                 const Align(
//                   alignment: Alignment.centerRight,
//                   child: Padding(
//                     padding: EdgeInsets.all(25.0),
//                     child: Image(
//                       image: AssetImage("assets/herble_logo.png"),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: globals.allInstructions!.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return Padding(
//                   padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8),
//                       color: const Color.fromARGB(255, 240, 240, 240),
//                     ),
//                     child: ExpansionTile(
//                       title: Text(
//                         globals.allInstructions![index].question,
//                         textAlign: TextAlign.left,
//                         style: GoogleFonts.inter(
//                           fontSize: globals.width * 0.018,
//                           fontWeight: FontWeight.w600,
//                           height: 1,
//                           color: const Color.fromARGB(255, 32, 54, 50),
//                         ),
//                       ),
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(10),
//                           child: _parseInstructionText(
//                             globals.allInstructions![index].answer,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _parseInstructionText(String instruction) {
//     List<InlineSpan> textSpans = [];

//     // Split the instruction text by " "
//     List<String> words = instruction.split(' ');

//     // Loop through each word and create a TextSpan with the appropriate style
//     for (int i = 0; i < words.length; i++) {
//       String word = words[i];

//       // Check if the word is enclosed in double quotes
//       if (word.startsWith('"') && word.endsWith('"')) {
//         textSpans.add(TextSpan(
//           text: word,
//           style: TextStyle(
//             color: Colors.red, // Set the color for words in double quotes to red
//             fontWeight: FontWeight.bold,
//           ),
//         ));
//       } else {
//         textSpans.add(TextSpan(
//           text: word,
//           style: TextStyle(color: Colors.black), // Default color for other words
//         ));
//       }

//       // Add a space after each word (except the last one)
//       if (i < words.length - 1) {
//         textSpans.add(TextSpan(text: ' '));
//       }
//     }

//     return RichText(
//       text: TextSpan(children: textSpans),
//     );
//   }
// }

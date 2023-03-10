import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:herble/individual_tip.dart';
import 'dart:convert';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;

class Tips extends StatefulWidget {
  const Tips({super.key});

  @override
  State<Tips> createState() => _TipsState();
}

class _TipsState extends State<Tips> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TipForm(),
    );
  }
}

class TipForm extends StatefulWidget {
  const TipForm({super.key});

  @override
  State<TipForm> createState() => _TipFormState();
}

class _TipFormState extends State<TipForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
              height: 100,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      "Tips",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
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
          // title: Text(globals.allTips![index].title),
          //     subtitle: Text(
          //         "${globals.allTips![index].description.substring(0, 50)}..."),
          //  onTap: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => IndividualTip(
          //             tip: globals.allTips![index],
          //           ),
          //         ),
          //       );
          //     },
          Expanded(
            child: ListView.builder(
              itemCount: globals.allTips!.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IndividualTip(
                          tip: globals.allTips![index],
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 5.0),
                    child: Container(
                      height: 400,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromARGB(255, 240, 240, 240)),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 15, 5, 0),
                                child: Text(
                                  globals.allTips![index].title,
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.cormorantGaramond(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    height: 1,
                                    color:
                                        const Color.fromARGB(255, 32, 54, 50),
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 15, 15, 0),
                                child: Center(
                                  child: Container(
                                      height: 250.0,
                                      width: 400,
                                      decoration: BoxDecoration(
                                        // borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                          image: index == 0
                                              ? const AssetImage(
                                                  'assets/temperatureTip.png')
                                              : const AssetImage(
                                                  'assets/dr.jpg'),
                                          fit: BoxFit.cover,
                                        ),
                                      )),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 15, 5, 0),
                                child: Text(
                                  ("${globals.allTips![index].description.substring(0, 50)}..."),
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.cormorantGaramond(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                    height: 1,
                                    color:
                                        const Color.fromARGB(255, 32, 54, 50),
                                  ),
                                ),
                              ),
                            ),
                          ],
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

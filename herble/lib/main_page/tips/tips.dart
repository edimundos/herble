import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:herble/main_page/tips/individual_tip.dart';
import '../../globals.dart' as globals;

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
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Tips",
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
      body: Column(
        children: [
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
                          borderRadius: BorderRadius.circular(10),
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
                                  style: GoogleFonts.inter(
                                    fontSize: globals.height * 0.009,
                                    fontWeight: FontWeight.bold,
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
                                          image: MemoryImage(
                                              globals.allTips![index].picture),
                                          fit: BoxFit.cover,
                                        ),
                                      )),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 0, 5, 0),
                                  child: Text(
                                    ("${globals.allTips![index].description.substring(0, 100)}..."),
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.inter(
                                      fontSize: globals.height * 0.008,
                                      fontWeight: FontWeight.normal,
                                      height: 1,
                                      color:
                                          const Color.fromARGB(255, 32, 54, 50),
                                    ),
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

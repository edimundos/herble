import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../globals.dart' as globals;
import '../main_page.dart';

class IndividualTip extends StatefulWidget {
  final globals.Tip tip;
  const IndividualTip({super.key, required this.tip});

  @override
  State<IndividualTip> createState() => _IndividualTipState();
}

class _IndividualTipState extends State<IndividualTip> {
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
                    padding: const EdgeInsets.all(20.0),
                    child: Material(
                      shape: const CircleBorder(),
                      clipBehavior: Clip.hardEdge,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return const MainPage(
                                  index: 2,
                                ); // Replace ChangeSettings with the actual widget for the settings page
                              },
                            ),
                          );
                        },
                        icon: Icon(Icons.arrow_back_sharp,
                            size: globals.width * 0.03, color: Colors.black26),
                      ),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: Text(
              widget.tip.title,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                height: 1,
                color: const Color.fromARGB(255, 32, 54, 50),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: Container(
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: MemoryImage(widget.tip.picture),
                    fit: BoxFit.cover,
                  ),
                )),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: Text(
              widget.tip.description,
              textAlign: TextAlign.left,
              style: GoogleFonts.inter(
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

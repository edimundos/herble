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
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        leading: IconButton(
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
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
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: MemoryImage(widget.tip.picture),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
              child: Text(
                widget.tip.description,
                textAlign: TextAlign.justify,
                style: GoogleFonts.inter(
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                  fontWeight: FontWeight.normal,
                  height: 1,
                  color: const Color.fromARGB(255, 32, 54, 50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

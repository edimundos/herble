import 'package:flutter/material.dart';
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
      appBar: AppBar(
        title: Text("Plant tips"),
        automaticallyImplyLeading: false,
      ),
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
      body: FutureBuilder(
        future: getAllTips(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<dynamic> tips = json
                .decode(snapshot.data ?? "[{}]")
                .map((data) =>
                    globals.Tip.fromJson(data as Map<String, dynamic>))
                .toList();
            return ListView.builder(
                itemCount: tips.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(tips[index].title),
                    subtitle: Text(tips[index].description),
                    onTap: () {
                      // globals.currentPlant = plants[index];
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => IndividualPlant(
                      //       plant: plants[index],
                      //       pic: plantPicData[index]!,
                      //     ),
                      //   ),
                      // );
                    },
                  );
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<String> getAllTips() async {
    String url = 'https://herbledb.000webhostapp.com/get_all_tips.php';
    try {
      var response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions here
      throw e;
    }
  }
}

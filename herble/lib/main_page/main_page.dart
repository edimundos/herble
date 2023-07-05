import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:herble/main_page/instructions/instructions.dart';
import 'package:herble/main_page/plants/plant_page.dart';
import 'package:herble/main_page/profile/profile_page.dart';
import 'package:herble/main_page/tips/tips.dart';

class MainPage extends StatefulWidget {
  int? index;
  MainPage({super.key, this.index});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  // final user = FirebaseAuth.instance.currentUser!;
  @override
  void initState() {
    super.initState();

    _selectedIndex = widget.index ?? 0;
  }

  static const List<Widget> _widgetOptions = <Widget>[
    Instructions(),
    PlantListScreen(),
    Tips(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    const Color bgcolor = Color.fromARGB(255, 182, 172, 152);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: SizedBox(
          height: 75,
          child: BottomNavigationBar(
            selectedItemColor: Color.fromARGB(255, 255, 255, 255),
            unselectedItemColor: Color.fromARGB(255, 56, 60, 68),
            showSelectedLabels: true,
            showUnselectedLabels: true,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.menu_book,
                ),
                label: 'instructions',
                backgroundColor: bgcolor,
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.list_alt_outlined,
                ),
                label: 'my plants',
                backgroundColor: bgcolor,
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.lightbulb,
                ),
                label: 'tips',
                backgroundColor: bgcolor,
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                ),
                label: 'profile',
                backgroundColor: bgcolor,
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}

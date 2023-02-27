import 'package:flutter/material.dart';
import 'package:herble/instructions.dart';
import 'package:herble/plant_page.dart';
import 'package:herble/profile_page.dart';
import 'package:herble/tips.dart';

class MainPage extends StatefulWidget {
  int? index;
  MainPage({super.key, this.index});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.blueGrey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.menu_book,
            ),
            label: 'instructions',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list_alt_outlined,
            ),
            label: 'my plants',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.lightbulb,
            ),
            label: 'tips',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: 'profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

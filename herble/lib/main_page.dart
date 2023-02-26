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
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.menu_book,
              color: Colors.blueGrey,
            ),
            label: 'instructions',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list_alt_outlined,
              color: Colors.blueGrey,
            ),
            label: 'my plants',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.lightbulb,
              color: Colors.blueGrey,
            ),
            label: 'tips',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.blueGrey,
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

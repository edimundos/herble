import 'package:flutter/material.dart';
import 'package:herble/colors.dart';
import 'package:herble/main_page/instructions/instructions.dart';
import 'package:herble/main_page/plants/plant_page.dart';
import 'package:herble/main_page/profile/profile_page.dart';
import 'package:herble/main_page/tips/tips.dart';
import '../globals.dart' as globals;

class MainPage extends StatefulWidget {
  final int? index;
  const MainPage({super.key, this.index});

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
          height: globals.height * 0.025,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: mainpallete.shade300,
            unselectedItemColor: Color.fromARGB(255, 20, 20, 20),
            showSelectedLabels: true,
            showUnselectedLabels: true,
            backgroundColor: Colors.white,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.menu_book,
                ),
                label: 'Instructions',
                backgroundColor: bgcolor,
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.list,
                ),
                label: 'My plants',
                backgroundColor: bgcolor,
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.lightbulb,
                ),
                label: 'Tips',
                backgroundColor: bgcolor,
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                ),
                label: 'Profile',
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

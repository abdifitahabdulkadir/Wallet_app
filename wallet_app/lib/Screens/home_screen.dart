import 'package:flutter/material.dart';

// my imports
import '../my_widgets/personal_profile.dart';
import '../my_widgets/setting.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<dynamic> _pages = [
    GetMappedCards(),
    Setting(),
  ];

  int _selectedPage = 0;

  void _goSelectedPage(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPage],
      bottomNavigationBar: BottomNavigationBar(
          onTap: _goSelectedPage,
          backgroundColor: Color.fromRGBO(23, 42, 135, 1),
          selectedFontSize: 20,
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.green,
          currentIndex: _selectedPage,
          items: [
            BottomNavigationBarItem(
              label: "Home",
              icon: Icon(Icons.home_filled, size: 30),
            ),
            BottomNavigationBarItem(
              label: "Setting",
              icon: Icon(Icons.settings, size: 30),
            )
          ]),
    );
  }
}

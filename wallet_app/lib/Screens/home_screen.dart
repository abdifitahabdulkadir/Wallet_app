import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

  
// my imports
import '../my_widgets/personal_profile.dart';
import '../my_widgets/setting.dart';
import '../my_widgets/favorite_cards.dart';

class Home extends ConsumerStatefulWidget {
  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
 
  final List<dynamic> _pages = [
    GetMappedCards(),
    Setting(),
    FavoritedCards(),
  ];

  int _selectedPage = 0;

  void _goSelectedPage(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  
  @override
  Widget build(BuildContext context) {
    double fontsize = 30;
    return Scaffold(
      body: _pages[_selectedPage],
      bottomNavigationBar: BottomNavigationBar(
          onTap: _goSelectedPage,
          backgroundColor: Color.fromRGBO(23, 42, 135, 1),
          selectedFontSize: 19,
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.yellow,
          currentIndex: _selectedPage,
          items: [
            BottomNavigationBarItem(
              label: "Home",
              icon: Icon(Icons.home_filled, size: 30),
            ),
            BottomNavigationBarItem(
              label: "Setting",
              icon: Icon(Icons.settings, size: 30),
            ),
            BottomNavigationBarItem(
              label: "Favorite Cards",
              icon: Icon(Icons.favorite_border_outlined, size: fontsize),
            )
          ]),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:wallet_app/main.dart';

// my imports
import '../my_widgets/personal_profile.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(children: [
        PersonalProfile(),
        SizedBox(height: 60),
        AddCard(),
        SizedBox(height: 30),
        Text("Recently Added Cards",
            style:
                TextStyle(color: Color.fromRGBO(23, 42, 135, 1), fontSize: 30)),
        SizedBox(height: 10),
        GetMappedCards(),
        HomeButtonDesign()
      ]),
    ));
  }
}

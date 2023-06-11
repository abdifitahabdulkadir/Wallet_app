import 'package:flutter/material.dart';

import './setting.dart';

class PersonalProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => Navigator.of(context).pushNamed(Setting.routeName),
          child: Container(
              margin: EdgeInsets.all(10),
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.transparent,
                border:
                    Border.all(color: Color.fromRGBO(23, 42, 135, 1), width: 2),
                image: DecorationImage(
                    image: AssetImage("assets/images/cat.png"),
                    fit: BoxFit.cover),
              ),
              child: null),
        ),
      ],
    );
  }
}

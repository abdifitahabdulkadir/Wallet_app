import 'package:flutter/material.dart';

// my own imports
import '../Screens/import_card.dart';

class AddCard extends StatelessWidget {
  _goImportCard(BuildContext context) {
    return Navigator.of(context).pushNamed(ImportCard.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _goImportCard(context),
      child: Container(
        width: 311,
        height: 63,
        decoration: BoxDecoration(
            color: Color.fromRGBO(23, 42, 135, 1),
            borderRadius: BorderRadius.circular(30)),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(
            Icons.add,
            color: Colors.white,
            size: 43,
          ),
          Text(
            "Add Cards",
            style: TextStyle(color: Colors.white, fontSize: 30),
          )
        ]),
      ),
    );
  }
}

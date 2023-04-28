import 'package:flutter/material.dart';

// my custom imports of flies
import '../Modal/home_modal.dart';
import '../my_widgets/display_recent_cards.dart';
import '../Screens/import_card.dart';

// perofile pricture
class PersonalProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            margin: EdgeInsets.all(10),
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border:
                  Border.all(color: Color.fromRGBO(23, 42, 135, 1), width: 2),
              image: DecorationImage(
                  image: AssetImage("assets/images/sundus.jpg"),
                  fit: BoxFit.cover),
            ),
            child: null),
        Text("Welcome again Abdifitah",
            style: TextStyle(
              color: Color.fromRGBO(23, 42, 135, 1),
              fontSize: 20,
            )) // Foreground widget here))
      ],
    );
  }
}

// for cards design
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
// am here

// returning the mapped the of every rectangle design
class GetMappedCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          PersonalProfile(),
          SizedBox(height: 60),
          AddCard(),
          SizedBox(height: 10),
          Text("Recently Added Cards",
              style: TextStyle(
                  color: Color.fromRGBO(23, 42, 135, 1), fontSize: 30)),
          SizedBox(height: 10),
          Expanded(
            child: GridView.count(
              childAspectRatio: 4 / 2,
              crossAxisCount: 2,
              children: [
                ...getIcons.map((eachIcon) {
                  return DisplayRecentCards(
                    getIcon: eachIcon.getIcon,
                  );
                })
              ],
            ),
          ),
        ],
      ),
    );
  }
}

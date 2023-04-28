import "package:flutter/material.dart";

class ImportCard extends StatelessWidget {
  static final String routeName = "/import_card";

  Widget _buildContainer(BuildContext context, {required IconData icon}) {
    return Container(
        margin: EdgeInsets.all(20.0),
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
            color: Colors.grey, borderRadius: BorderRadius.circular(13)),
        child: Icon(
          icon,
          color: Theme.of(context).primaryColor,
          size: 60.0,
        ));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(23, 42, 135, 1),
        leading: BackButton(
            color: Colors.white, onPressed: () => Navigator.pop(context)),
      ),
      body: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 45.0),
          margin: EdgeInsets.all(70.0),
          child: Text(
            "Select Card icon",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        Row(
          children: [
            _buildContainer(context, icon: Icons.search),
            _buildContainer(context, icon: Icons.image),
            _buildContainer(context, icon: Icons.camera_alt)
          ],
        ),
      ]),
    );
  }
}

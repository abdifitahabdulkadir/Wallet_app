import 'package:flutter/material.dart';

class ImageFromWeb extends StatelessWidget {
  static final String routeName = "/imagefroweb";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(child: Text("wait web image will come soon")),
    );
  }
}

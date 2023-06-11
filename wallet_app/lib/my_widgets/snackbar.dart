import 'package:flutter/material.dart';

@override
customeSnackBar({required BuildContext context, required String text}) {
  final snackbar = SnackBar(
      duration: Duration(microseconds: 30),
      backgroundColor: Theme.of(context).primaryColor,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontStyle: FontStyle.italic,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.emoji_emotions_rounded,
              color: Colors.white,
              size: 50,
            ),
          )
        ],
      ));
  return snackbar;
}

import 'package:flutter/material.dart';

class DisplayRecentCards extends StatelessWidget {
  final Icon getIcon;
  DisplayRecentCards({required this.getIcon});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 180,
          height: 62,
          decoration: BoxDecoration(
            color: Color.fromRGBO(217, 217, 217, 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(getIcon.icon),
        )
      ],
    );
  }
}

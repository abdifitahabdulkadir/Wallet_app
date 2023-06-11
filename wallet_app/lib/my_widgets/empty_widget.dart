import "package:flutter/material.dart";
import 'package:transparent_image/transparent_image.dart';

Widget emptyContainer() {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: 400,
        width: 380,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white30, width: 3)),
        child: FadeInImage(
          placeholder: MemoryImage(kTransparentImage),
          fit: BoxFit.cover,
          image: AssetImage("assets/images/notfoundimage.png"),
        ),
      ),
    ),
  );
}

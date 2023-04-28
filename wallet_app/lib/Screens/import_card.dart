import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// my imports
import '../Screens/image_from_web.dart';

class ImportCard extends StatefulWidget {
  static final String routeName = "/import_card";

  @override
  State<ImportCard> createState() => _ImportCardState();
}

class _ImportCardState extends State<ImportCard> {
  File? imagePath;

  // builder that holds the container of imagecion, search icon and camera icon.
  Widget _buildContainer(BuildContext context,
      {required IconData icon,
      required ImageSource getSource,
      bool isSearch = false}) {
    return GestureDetector(
      onTap: () {
        if (isSearch)
          Navigator.of(context).pushNamed(ImageFromWeb.routeName);
        else
          _tapHandler(source: getSource);
      },
      child: Container(
          margin: EdgeInsets.all(20.0),
          padding: EdgeInsets.all(15.0),
          decoration: BoxDecoration(
              color: Colors.grey, borderRadius: BorderRadius.circular(13)),
          child: Icon(
            icon,
            color: Theme.of(context).primaryColor,
            size: 60.0,
          )),
    );
  }

  // function that triggers when we click gallery, search or camera icon.
  _tapHandler({required ImageSource source}) async {
    try {
      final image = await ImagePicker().pickImage(source: source);

      if (image?.path != null) {
        setState(() {
          imagePath = File(image!.path);
        });
      }
    } catch (error) {
      print(error);
    }
  }

  // builder for containe that holds image or not found message if
  // we dont found image from gallery or file.

  Widget _buildContainerOfImage(
      {File? image, AssetImage? notFoundImage, required bool isFound}) {
    final findImage;
    if (isFound)
      findImage = FileImage(image!);
    else
      findImage = notFoundImage;
    return Container(
      height: 300,
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white12,
        image: DecorationImage(
          image: findImage,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(23, 42, 135, 1),
        leading: BackButton(
            color: Colors.white, onPressed: () => Navigator.pop(context)),
      ),
      body: Column(children: [
        SizedBox(height: 50),
        Container(
          margin: EdgeInsets.all(5),
          child: Container(
            height: 50,
            width: 700,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Import Your Card",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(23, 42, 135, 1),
              ),
            ),
          ),
        ),
        Row(
          children: [
            _buildContainer(context,
                icon: Icons.search,
                isSearch: true,
                getSource: ImageSource.gallery),
            _buildContainer(context,
                icon: Icons.image, getSource: ImageSource.gallery),
            _buildContainer(context,
                icon: Icons.camera_alt, getSource: ImageSource.camera)
          ],
        ),
        imagePath?.path != null
            ? _buildContainerOfImage(image: imagePath!, isFound: true)
            : _buildContainerOfImage(
                notFoundImage: AssetImage("assets/images/cat.png"),
                isFound: false)
      ]),
    );
  }
}

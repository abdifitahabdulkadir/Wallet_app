import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../wallet_providers/authentication_provider.dart';

class ImportCard extends ConsumerStatefulWidget {
  static final String routeName = "/import_card";

  @override
  ConsumerState<ImportCard> createState() => _ImportCardState();
}

class _ImportCardState extends ConsumerState<ImportCard> {
  File? imagePath;
  bool isLoading = false;

  String _imageTitle = "";
  String _categoryName = "";
  final formKey = GlobalKey<FormState>();

  // builder that holds the container of imagecion, search icon and camera icon.
  void pickImage({required ImageSource source}) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        setState(() {
          imagePath = File(pickedImage.path);
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  Widget _buildContainerOfImage({File? image, required bool isFound}) {
    if (image != null) {
      return FittedBox(
        child: Container(
          height: 200,
          width: 380,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white12,
            image: DecorationImage(
              image: FileImage(image),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }
    return Container();
  }

  _buildImageInformation({required String imageUrl}) {
    print(imageUrl);
    return SizedBox(
      height: 200,
      child: Card(
        elevation: 4,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 20, bottom: 20, right: 10, left: 10),
          child: Form(
              key: formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.green,
                          )),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "Image title",
                          prefixIcon: Icon(Icons.title_sharp),
                        ),
                        enableSuggestions: false,
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.name,
                        validator: (enteredTitlte) {
                          if (enteredTitlte == null)
                            return "Title field* is mondotory";
                          return null;
                        },
                        onSaved: (titleValue) => _imageTitle = titleValue!,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.green,
                          )),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "Category name",
                          prefixIcon: Icon(Icons.category),
                        ),
                        enableSuggestions: false,
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.name,
                        validator: (categoryName) {
                          if (categoryName == null)
                            return "Category field* is mondotory";
                          return null;
                        },
                        onSaved: (categoryName) =>
                            _categoryName = categoryName!,
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  void _isDocumentExisted(
      {required String userid, required String image_title}) async {
    setState(() {
      isLoading = true;
      FocusScope.of(context).unfocus();
    });

    final activeHomeCards =
        await ref.read(firebaseFirestoreProvider).collection("usersdata").get();
    bool isExisted = false;
    String username = "";

    for (int j = 0; j < activeHomeCards.docs.length; j++) {
      if (activeHomeCards.docs[j].data()["userid"] == userid) {
        username = activeHomeCards.docs[j].data()["username"];
        break;
      }
    }
    for (int k = 0; k < activeHomeCards.docs.length; k++) {
      if (activeHomeCards.docs[k].data()["userid"] == userid &&
              activeHomeCards.docs[k]
                      .data()["image_title"]
                      .toString()
                      .toLowerCase() ==
                  image_title.toLowerCase() ||
          activeHomeCards.docs[k]
                  .data()["image_title"]
                  .toString()
                  .toUpperCase() ==
              image_title.toUpperCase()) {
        isExisted = true;

        break;
      }
    }

    if (username.isEmpty || image_title.isEmpty) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Title must not empty or username is empty ")));
    } else {
      _savingDataIntoDatabase(
        imageTitle: image_title,
        isExisted: isExisted,
        userid: userid,
        username: username,
        categoryName: _categoryName,
      );
    }
  }

  // storing the
  void _savingDataIntoDatabase(
      {required String imageTitle,
      required String username,
      required String userid,
      required String categoryName,
      required bool isExisted}) async {
    try {
      if (isExisted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("$imageTitle is already exists in your account!")));
      } else {
        final storagePath = await ref
            .read(firebaseStorageProvider)
            .ref()
            .child("uploaded_cards")
            .child("${imageTitle}.jpng");
        await storagePath.putFile(imagePath!);

        String imageUrl = await storagePath.getDownloadURL();
        final referece = await ref
            .read(firebaseFirestoreProvider)
            .collection("usersdata")
            .add({
          "username": username,
          "userid": userid,
          "image_title": imageTitle,
          "image_url": await imageUrl,
          "category": categoryName,
        });
        if (referece.id.isNotEmpty)
          ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("$imageTitle has been saved SuccessFully")));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("$error")));
    }
    setState(() {
      isLoading = false;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
          backgroundColor: Color.fromRGBO(23, 42, 135, 1),
          leading: BackButton(
              color: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                FocusScope.of(context).unfocus();
                Navigator.pop(context);
              })),
      body: SingleChildScrollView(
        child: Column(children: [
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
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            InkWell(
              onTap: () => pickImage(source: ImageSource.camera),
              child: Container(
                  margin: EdgeInsets.all(20.0),
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(13)),
                  child: Icon(
                    Icons.camera_alt,
                    color: Theme.of(context).primaryColor,
                    size: 60.0,
                  )),
            ),
            InkWell(
              onTap: () => pickImage(source: ImageSource.gallery),
              child: Container(
                  margin: EdgeInsets.all(20.0),
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(13)),
                  child: Icon(
                    Icons.photo,
                    color: Theme.of(context).primaryColor,
                    size: 60.0,
                  )),
            ),
          ]),
          if (imagePath != null)
            _buildContainerOfImage(isFound: true, image: imagePath),
          SizedBox(height: 10),
          if (imagePath != null)
            _buildImageInformation(imageUrl: imagePath!.path),
          SizedBox(height: 10),
          if (imagePath != null)
            isLoading
                ? CircularProgressIndicator()
                : Container(
                    height: 50,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton.icon(
                        onPressed: () {
                          formKey.currentState!.validate();
                          formKey.currentState!.save();
                          try {
                            _isDocumentExisted(
                                image_title: _imageTitle,
                                userid: ref
                                    .watch(firebaseAuthProvider)
                                    .currentUser!
                                    .uid);
                            formKey.currentState!.reset();
                          } catch (error) {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("$error")));
                          }
                        },
                        icon: Icon(
                          Icons.save,
                          color: Colors.white,
                        ),
                        label: Text(
                          "Save Data",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )),
                  ),
        ]),
      ),
    );
  }
}

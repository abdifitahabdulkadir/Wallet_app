import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

// imports my things
import 'package:wallet_app/wallet_providers/authentication_provider.dart';

class AccountManage extends ConsumerStatefulWidget {
  static final String routeName = "/accountmanage";

  @override
  ConsumerState<AccountManage> createState() => _AccountManageState();
}

class _AccountManageState extends ConsumerState<AccountManage> {
  String? username;
  File? imagePath;
  void pickImage() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          imagePath = File(pickedImage.path);
          _updateProfileImage(fileImage: imagePath!);
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  Future<bool> _updateProfileImage({required File fileImage}) async {
    bool isUpdated = false;

    final storagePath = await ref
        .read(firebaseStorageProvider)
        .ref()
        .child("usersImage")
        .child("${ref.read(firebaseAuthProvider).currentUser!.uid} .jpng");

    await storagePath.putFile(imagePath!);

    final String imageUrl = await storagePath.getDownloadURL();
    await ref
        .read(firebaseFirestoreProvider)
        .collection("userInfo")
        .doc(ref.read(firebaseAuthProvider).currentUser!.uid)
        .update({"profile_image": imageUrl});
    return isUpdated;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          SizedBox(height: 20),
          Padding(
              padding: EdgeInsets.only(left: 150, right: 120),
              child: FutureBuilder(
                future: ref
                    .watch(firebaseFirestoreProvider)
                    .collection("userInfo")
                    .get(),
                builder: (_, eachUserInformation) {
                  if (eachUserInformation.connectionState ==
                      ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());

                  for (int k = 0;
                      k < eachUserInformation.data!.docs.length;
                      k++)
                    if (eachUserInformation.data!.docs[k].data()["userid"] ==
                        ref.watch(firebaseAuthProvider).currentUser!.uid) {
                      username =
                          eachUserInformation.data!.docs[k].data()["username"];
                      return Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(
                                    eachUserInformation.data!.docs[k]
                                        .data()["profile_image"])),
                            TextButton(
                                onPressed: pickImage,
                                child: Text(
                                  "Edit",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                )),
                          ],
                        ),
                      );
                    }
                  return CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        NetworkImage(ref.watch(defualtImagelinkProvider)),
                  );
                },
              )),
          Divider(
            height: 3,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}

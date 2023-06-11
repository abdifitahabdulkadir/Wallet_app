import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparent_image/transparent_image.dart';

//
import '../wallet_providers/authentication_provider.dart';

class CardView extends ConsumerStatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> getImageData;
  CardView({required this.getImageData});

  @override
  ConsumerState<CardView> createState() => _CardViewState();
}

class _CardViewState extends ConsumerState<CardView> {
  // variable for sending
  bool _isExisted = false;
  // image builder
  Widget _imageBuilder({required String imageUrl}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: 400,
        width: 380,
        decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.blue, width: 3)),
        child: FadeInImage(
          placeholder: MemoryImage(kTransparentImage),
          fit: BoxFit.cover,
          image: NetworkImage(imageUrl),
        ),
      ),
    );
  }

  // storing the value of favorites inside the database
  void _submitFavoritesIntoDatabase(
      {required String userid,
      required String username,
      required String image_url,
      required String image_title}) async {
    if (userid.isEmpty ||
        username.isEmpty ||
        image_title.isEmpty ||
        image_url.isEmpty)
      return;
    else {
      try {
        final activeFavorites = await ref
            .read(firebaseFirestoreProvider)
            .collection("favorites")
            .get();

        String documentId = '';
        for (int k = 0; k < activeFavorites.docs.length; k++) {
          if (activeFavorites.docs[k]["userid"] == userid &&
              activeFavorites.docs[k]["image_title"] == image_title) {
            documentId = activeFavorites.docs[k].id;
            _isExisted = true;
            break;
          }
        }
        if (_isExisted == false) {
          await ref
              .read(firebaseFirestoreProvider)
              .collection("favorites")
              .add({
            "userid": userid,
            "image_url": image_url,
            "image_title": image_title,
            "username": username,
          });

          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("${image_title} has been added Favorites")));
        } else {
          await ref
              .read(firebaseFirestoreProvider)
              .collection("favorites")
              .doc(documentId)
              .delete();
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("${image_title} has been deleted Favorites")));
        }
      } catch (error) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("$error")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.getImageData["image_title"]),
        backgroundColor: Theme.of(context).primaryColor,
        leading: BackButton(
          color: Colors.white,
          onPressed: Navigator.of(context).pop,
        ),
        actions: [
          IconButton(
              onPressed: () {
                _submitFavoritesIntoDatabase(
                  image_title: widget.getImageData["image_title"],
                  image_url: widget.getImageData["image_url"],
                  userid: ref.watch(firebaseAuthProvider).currentUser!.uid,
                  username: widget.getImageData["username"],
                );
              },
              icon: Icon(
                _isExisted ? Icons.star : Icons.star_border,
                size: 30,
              ))
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 50),
          _imageBuilder(
            imageUrl: widget.getImageData["image_url"].toString(),
          ),
        ],
      ),
    );
  }
}

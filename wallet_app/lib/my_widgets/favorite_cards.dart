import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Screens/card_view.dart';
import '../wallet_providers/authentication_provider.dart';
import "./empty_widget.dart";

class FavoritedCards extends ConsumerWidget {
  Widget _imageBuilder({required String imageUrl, required String title}) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 15),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
                color: Color.fromARGB(255, 221, 224, 227), width: 3)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 70,
              width: 70,
              child: CircleAvatar(
                backgroundImage: NetworkImage(imageUrl),
              ),
            ),
            SizedBox(width: 20),
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
              ),
            )
          ],
        ),
      ),
    );
  }

  _getStreamData({required WidgetRef ref}) {
    return StreamBuilder(
        stream: ref
            .watch(firebaseFirestoreProvider)
            .collection("favorites")
            .snapshots(),
        builder: (_, eachSnapshoots) {
          if (eachSnapshoots.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          if (!eachSnapshoots.hasData) return Text("Failed No Data found");
          final filteredData = eachSnapshoots.data!.docs
              .where((element) =>
                  element["userid"] ==
                  ref.watch(firebaseAuthProvider).currentUser!.uid)
              .toList();

          if (filteredData.isEmpty) return emptyContainer();
          return ListView.builder(
              shrinkWrap: true,
              itemCount: filteredData.length,
              itemBuilder: (context, index) {
                return SizedBox(
                    width: 100,
                    height: 100,
                    child: InkWell(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) {
                        return CardView(getImageData: filteredData[index]);
                      })),
                      child: _imageBuilder(
                        imageUrl: filteredData[index]["image_url"],
                        title: filteredData[index]["image_title"],
                      ),
                    ));
              });
        });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _getStreamData(ref: ref);
  }
}

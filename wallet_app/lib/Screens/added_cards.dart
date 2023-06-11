import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// custom imports
import '../screens/card_view.dart';
import '../wallet_providers/authentication_provider.dart';
import "../my_widgets/empty_widget.dart";

class AddedCards extends ConsumerStatefulWidget {
  static final String routeName = "/added_cards";

  @override
  ConsumerState<AddedCards> createState() => _AddedCardsState();
}

class _AddedCardsState extends ConsumerState<AddedCards> {
  // builder of listie
  Widget _buildlistTile(
      {required BuildContext context,
      required String title,
      required IconData icon,
      required DateTime date,
      required Widget addHomeButton}) {
    return Container(
        height: 100,
        width: 360,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: Color.fromRGBO(217, 217, 217, 1),
        ),
        child: Center(
          child: ListTile(
            leading: Icon(
              Icons.work,
              color: Theme.of(context).primaryColor,
              size: 50,
            ),
            title: FittedBox(
              child: Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 25,
                  fontFamily: "Roboto",
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            subtitle: Text(
              "Date: ${DateFormat("MM/dd/yy h:mm:ss").format(date)}",
              style: TextStyle(
                color: Theme.of(context).primaryColor.withOpacity(0.5),
                fontSize: 15,
                fontStyle: FontStyle.italic,
              ),
            ),
            trailing: addHomeButton,
          ),
        ));
  }

  Future<Map<String, Object>> isDocumentExisted(
      {required String userid, required String image_title}) async {
    final activeHomeCards = await ref
        .read(firebaseFirestoreProvider)
        .collection("addedhomecards")
        .get();
    bool isExisted = false;
    String documentId = '';
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
        documentId = activeHomeCards.docs[k].id;
        isExisted = true;
        break;
      }
    }
    return {"documentId": documentId, "isExisted": isExisted};
  }

  // storing the value of favorites inside the database
  void _submitHomeAddedCardsIntoDatabase(
      {required String userid,
      required String categoryName,
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
        final validatedData =
            await isDocumentExisted(image_title: image_title, userid: userid);
        final isExisted = validatedData["isExisted"];
        final documentId = validatedData["documentId"];
        if (isExisted == false) {
          await ref
              .read(firebaseFirestoreProvider)
              .collection("addedhomecards")
              .add({
            "userid": userid,
            "image_url": image_url,
            "image_title": image_title,
            "username": username,
            "category": categoryName,
          });

          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("${image_title} has been added Home")));
        } else {
          await ref
              .read(firebaseFirestoreProvider)
              .collection("addedhomecards")
              .doc(documentId.toString())
              .delete();
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("${image_title} has been deleted Home")));
        }
      } catch (error) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("$error")));
      }
    }
  }

  // addHomeButtonDesign
  Widget _buildAddHomeButton(
      {required String userid,
      required String username,
      required String image_url,
      required String categoryName,
      required String image_title}) {
    return Container(
      height: 50,
      width: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).primaryColor,
      ),
      child: Center(
          child: Transform.scale(
              scale: 2,
              child: TextButton(
                  onPressed: () {
                    _submitHomeAddedCardsIntoDatabase(
                      image_title: image_title,
                      userid: userid,
                      username: username,
                      image_url: image_url,
                      categoryName: categoryName,
                    );
                  },
                  child: FittedBox(
                      child: Text(
                    "Add Home",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ))))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ref.watch(addedCardsFilterProvider).isEmpty
            ? "Recently Added Cards"
            : ref.watch(addedCardsFilterProvider) + " Cards"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
        child: Center(
            child: ListView(children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: StreamBuilder(
              stream: ref
                  .watch(firebaseFirestoreProvider)
                  .collection("usersdata")
                  .snapshots(),
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
                  return emptyContainer();

                final currentUsersData = ref
                        .watch(addedCardsFilterProvider)
                        .isEmpty
                    ? snapshot.data!.docs.where((element) {
                        return element.data()["userid"] ==
                            ref.watch(firebaseAuthProvider).currentUser!.uid;
                      }).toList()
                    : snapshot.data!.docs.where((element) {
                        return element.data()["userid"] ==
                                ref
                                    .watch(firebaseAuthProvider)
                                    .currentUser!
                                    .uid &&
                            element.data()["category"] ==
                                ref.watch(addedCardsFilterProvider);
                      }).toList();

                return ListView.builder(
                    itemCount: currentUsersData.length,
                    itemBuilder: ((context, index) {
                      return InkWell(
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) {
                          return CardView(
                              getImageData: currentUsersData[index]);
                        })),
                        child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: _buildlistTile(
                              context: context,
                              title:
                                  currentUsersData[index].data()["image_title"],
                              icon: Icons.add,
                              date: DateTime.now(),
                              addHomeButton: _buildAddHomeButton(
                                image_title: currentUsersData[index]
                                    .data()["image_title"],
                                userid: ref
                                    .watch(firebaseAuthProvider)
                                    .currentUser!
                                    .uid,
                                categoryName:
                                    currentUsersData[index].data()["category"],
                                username:
                                    currentUsersData[index].data()["username"],
                                image_url:
                                    currentUsersData[index].data()["image_url"],
                              ),
                            )),
                      );
                    }));
              }),
            ),
          )
        ])),
      ),
    );
  }
}

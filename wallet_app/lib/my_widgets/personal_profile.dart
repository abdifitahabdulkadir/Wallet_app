import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// my custom imports of flies
import '../Screens/added_cards.dart';
import '../my_widgets/display_recent_cards.dart';
import './side_bar_drawer.dart';
import '../wallet_providers/authentication_provider.dart';

// returning the mapped the of every rectangle design
class GetMappedCards extends ConsumerWidget {
  // image builder for showing you dont add any thing to the home

  _buildImage() {
    return Container(
      height: 300,
      width: 400,
      decoration: BoxDecoration(borderRadius: BorderRadius.zero),
      child: Image.asset("assets/images/loadingimage.png"),
    );
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        drawer: SideBarDrawer(),
        body: SafeArea(
            child: StreamBuilder(
          stream: ref
              .watch(firebaseFirestoreProvider)
              .collection("addedhomecards")
              .snapshots(),
          builder: (_, eachSnapshot) {
            if (eachSnapshot.connectionState == ConnectionState.waiting)
              return Center(
                child: CircularProgressIndicator(),
              );

            final filteredData = eachSnapshot.data!.docs
                .where((element) =>
                    element["userid"] ==
                    ref.watch(firebaseAuthProvider).currentUser!.uid)
                .toList();
            if (filteredData.isEmpty) return _buildImage();

            return GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1,
                ),
                itemCount: filteredData.length > 10
                    ? filteredData.length ~/ 2
                    : filteredData.length,
                itemBuilder: (_, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(AddedCards.routeName);
                      ref.watch(addedCardsFilterProvider.notifier).state =
                          filteredData[index].data()["category"];
                    },
                    child: DisplayRecentCards(
                        category: filteredData[index].data()["category"],
                        title: filteredData[index].data()["image_title"]),
                  );
                });
          },
        )));
  }
}

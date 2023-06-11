import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// custom imports
import '../Screens/added_cards.dart';
import '../Screens/import_card.dart';
import '../wallet_providers/authentication_provider.dart';
import '../my_widgets/setting.dart';

class SideBarDrawer extends ConsumerStatefulWidget {
  @override
  ConsumerState<SideBarDrawer> createState() => _SideBarDrawerState();
}

class _SideBarDrawerState extends ConsumerState<SideBarDrawer> {
  // builder for listie
  Widget _buildListTile(
      {required BuildContext context,
      required IconData icon,
      required String text}) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).primaryColor,
        size: 30,
      ),
      title: Text(
        text,
        style: TextStyle(
          fontWeight: Theme.of(context).textTheme.bodyLarge!.fontWeight,
          color: Theme.of(context).primaryColor,
          fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String username = "";
    return Drawer(
      backgroundColor: Colors.white,
      elevation: 10,
      width: 240,
      child: Column(
        children: [
          SizedBox(height: 55),
          FutureBuilder(
              future: ref
                  .watch(firebaseFirestoreProvider)
                  .collection("userInfo")
                  .get(),
              builder: (_, eachValue) {
                if (eachValue.connectionState == ConnectionState.waiting)
                  return FittedBox(child: CircularProgressIndicator());
                if (!eachValue.hasData) return Text("loading...");

                final currentUserData = eachValue.data!.docs;
                for (int k = 0; k < currentUserData.length; k++)
                  if (currentUserData[k].data()["userid"] ==
                      ref.watch(firebaseAuthProvider).currentUser!.uid) {
                    username = currentUserData[k].data()["username"];
                    return Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                              currentUserData[k].data()["profile_image"] ??
                                  ref.watch(defualtImagelinkProvider)),
                        ),
                        Text(
                          username,
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        )
                      ],
                    );
                  }
                return Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          NetworkImage(ref.watch(defualtImagelinkProvider)),
                    ),
                    Text(
                      username,
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    )
                  ],
                );
                ;
              }),
          Divider(height: 10, color: Color.fromARGB(255, 42, 40, 40)),
          GestureDetector(
            onTap: () {
              Navigator.of(context).popAndPushNamed(AddedCards.routeName);
              ref.watch(addedCardsFilterProvider.notifier).state = "";
            },
            child: _buildListTile(
                context: context, icon: Icons.card_travel, text: "Added Cards"),
          ),
          GestureDetector(
            onTap: () =>
                Navigator.of(context).popAndPushNamed(Setting.routeName),
            child: _buildListTile(
                context: context, icon: Icons.settings, text: "Setting"),
          ),
          GestureDetector(
            onTap: () =>
                Navigator.of(context).popAndPushNamed(ImportCard.routeName),
            child: _buildListTile(
                context: context, icon: Icons.credit_card, text: "Add Card"),
          ),
          GestureDetector(
            onTap: () => ref.watch(firebaseAuthProvider).signOut(),
            child: _buildListTile(
                context: context, icon: Icons.login, text: "Logout"),
          ),
        ],
      ),
    );
  }
}

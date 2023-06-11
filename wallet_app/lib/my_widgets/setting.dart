import 'package:flutter/material.dart';


// custom imports
import '../my_widgets/profile_person.dart';
import '../Screens/account_manage.dart';

class Setting extends StatelessWidget {
  static final String routeName = "/setting";

  // build buttons and clicks
  _buildButtons(
      {required String dispalyText,
      required IconData icon,
      required BuildContext context}) {
    return Container(
      margin: const EdgeInsets.only(
          top: 15), // Adds 16 pixels of margin on all sides

      child: ListTile(
        title: Text(
          dispalyText,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 25,
                fontWeight: FontWeight.normal,
              ),
        ),
        leading: Icon(icon),
        onTap: () {
          Navigator.of(context).pushNamed(AccountManage.routeName);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Color.fromRGBO(23, 42, 135, 1),
      ),
      body: Column(
        children: [
          SizedBox(height: 50),
          _buildButtons(
            dispalyText: "Account Management",
            icon: Icons.person,
            context: context,
          ),
          _buildButtons(
            dispalyText: "Security",
            icon: Icons.security,
            context: context,
          ),
          _buildButtons(
            dispalyText: "Personalize",
            icon: Icons.settings_suggest,
            context: context,
          ),
          _buildButtons(
            dispalyText: "Logout",
            icon: Icons.logout,
            context: context,
          ),
        ],
      ),
    );
  }
}

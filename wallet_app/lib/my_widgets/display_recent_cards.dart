import 'package:flutter/material.dart';

class DisplayRecentCards extends StatelessWidget {
 
  final String title;
  final String category;

  DisplayRecentCards({required this.title, required this.category});

  // ddecising the Icon
  IconData getCategoryIcon({required String category}) {
    switch (category) {
      case "Medince":
        return Icons.medical_services_rounded;
      case "Education":
        return Icons.school_rounded;

      case "Transportation":
        return Icons.emoji_transportation;

      case "Business":
        return Icons.business_center_rounded;

      case "Bank":
        return Icons.account_balance;
    }
    return Icons.wallet;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(15),
        width: 280,
        height: 40,
        decoration: BoxDecoration(
          color: Color.fromRGBO(243, 239, 239, 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              getCategoryIcon(category: category),
              size: 80,
              color: Theme.of(context).primaryColor,
            ),
            FittedBox(
                child: Text(title,
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.bodyLarge!.fontFamily,
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,
                    ))),
          ],
        ));
  }
}

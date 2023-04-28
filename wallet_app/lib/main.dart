import 'package:flutter/material.dart';

// my custom imports
import './Screens/home_screen.dart';
import './Screens/import_card.dart';
import './Screens/image_from_web.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

@override
  Widget build(BuildContext context) {
    return MaterialApp(

      initialRoute: "/",
      routes: {
        "/": (context) => Home(),
        ImportCard.routeName: (context) => ImportCard(),
        ImageFromWeb.routeName: (context) => ImageFromWeb()
      },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          primaryColor: Color.fromRGBO(23, 42, 135, 1),
          textTheme: TextTheme(
              bodyLarge: TextStyle(
              color: Colors.blue,
            fontFamily: "Roboto",
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          )
      
      ),
      // home: Home(),
    );
  }
}

// returning the home bottom design to use again and again


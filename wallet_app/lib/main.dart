import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallet_app/Screens/import_card.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// my custom imports
import './Screens/home_screen.dart';
import './Screens/added_cards.dart';
import 'my_widgets/setting.dart';
import './Screens/register.dart';
import './Screens/account_manage.dart';
import '../wallet_providers/authentication_provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      home: StreamBuilder(
        stream: ref.watch(firebaseAuthProvider).authStateChanges(),
        builder: (_, snapshoots) {
          if (snapshoots.connectionState == ConnectionState.waiting)
            return CircularProgressIndicator();

          if (snapshoots.hasData) return Home();
          return Register();
        },
      ),
      routes: {
       
        AddedCards.routeName: (context) => AddedCards(),
        Setting.routeName: (context) => Setting(),
        Register.routeName: (context) => Register(),
        ImportCard.routeName: (context) => ImportCard(),
        AccountManage.routeName: (context) => AccountManage(),
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
          )),
      // home: Home(),
    );
  }
}

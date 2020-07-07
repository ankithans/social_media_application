import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_application/ui/views/authentication/welcomePage.dart';
import 'package:social_media_application/ui/views/page_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool login = prefs.getBool("isLoggedIn");
  print("login:" + login.toString());
  runApp(
    MaterialApp(
      home: login == null ? WelcomePage() : PageControl(),
    ),
  );
}

// class MyApp extends StatefulWidget {
//   // This widget is the root of your application.
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   bool boolValue = false;
//   getBoolValuesSF() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     //Return bool
//     boolValue = prefs.getBool('isLoggedIn');
//     return boolValue;
//   }

//   @override
//   void initState() {
//     super.initState();
//     getBoolValuesSF();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: boolValue ? PageControl() : WelcomePage(),
//     );
//   }
// }

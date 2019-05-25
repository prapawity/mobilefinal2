import 'package:flutter/material.dart';
import 'package:mobilefinal_60070045/view/list_friend_user.dart';
import 'package:mobilefinal_60070045/view/login.dart';
import 'package:mobilefinal_60070045/view/mainpage.dart';
import 'package:mobilefinal_60070045/view/profile_current_user.dart';
import 'package:mobilefinal_60070045/view/register_user.dart';
void main() => runApp(MyApp());
const MaterialColor white = const MaterialColor(
  0xFF4e69a2,
  const <int, Color>{
    50: const Color(0xFF4e69a2),
    100: const Color(0xFF4e69a2),
    200: const Color(0xFF4e69a2),
    300: const Color(0xFF4e69a2),
    400: const Color(0xFF4e69a2),
    500: const Color(0xFF4e69a2),
    600: const Color(0xFF4e69a2),
    700: const Color(0xFF4e69a2),
    800: const Color(0xFF4e69a2),
    900: const Color(0xFF4e69a2),
  },
);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Prepared',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: white,
        iconTheme: IconThemeData(color: Color(0xFF4e69a2)),
      ),
      initialRoute: "/",
      
      routes: {
        "/": (context) => Login(),
        "/register": (context) => Register(),
        "/mainpage": (context) => MainPage(),
        "/profile": (context) => Profile_User(),
        "/allfriend": (context) => List_Friend_Current_User(),
      },
    );
  }
}

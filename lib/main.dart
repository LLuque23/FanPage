import 'package:fan_page/Screens/home/home_screen.dart';
import 'package:fan_page/Screens/register/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Screens/login/login_screen.dart';
import 'Screens/register/register_info_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // print(DateTime.now().toString());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Firebase Demo',
        home: const LoginScreen(),
        routes: <String, WidgetBuilder>{
          '/login': (BuildContext context) => const LoginScreen(),
          '/register': (BuildContext context) => const RegisterScreen(),
          '/home': (BuildContext context) => const HomeScreen(),
          '/register_info': (BuildContext context) => const RegisterInfoScreen()
        });
  }
}

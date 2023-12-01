import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipient/Provider.dart';
import 'package:recipient/add/add_screen.dart';
import 'package:recipient/firebase_options.dart';
import 'package:recipient/home_screen.dart';
import 'package:recipient/login/login_screen.dart';
import 'package:recipient/profile_screen.dart';
import 'package:recipient/util.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MainProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
                title: 'Flutter Demo',
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                ),
                home: FirebaseAuth.instance.currentUser != null
                    ? const MyMainPage()
                    : const LoginScreen());
          }

          return const SizedBox();
        });
  }
}

class MyMainPage extends StatefulWidget {
  const MyMainPage({Key? key}) : super(key: key);

  @override
  State<MyMainPage> createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MyMainPage> {
  int _navSelectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: "home"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.add_box_outlined,
                ),
                label: "add"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_circle_rounded,
                ),
                label: "profile")
          ],
          selectedLabelStyle: const TextStyle(
            fontFamily: 'Mukta',
            fontWeight: FontWeight.w600,
          ),
          showUnselectedLabels: false,
          showSelectedLabels: false,
          selectedItemColor: mainColor,
          currentIndex: _navSelectedIndex,
          onTap: (index) {
            setState(() {
              _navSelectedIndex = index;
            });
          },
        ),
        body: _navSelectedIndex == 0
            ? const HomeScreen()
            : _navSelectedIndex == 1
                ? const AddScreen()
                : const ProfileScreen());
  }
}

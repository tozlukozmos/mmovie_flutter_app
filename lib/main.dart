import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'views/feed.dart';
import 'views/login.dart';
import 'views/movie_detail.dart';
import 'views/see_more.dart';
import 'views/signup.dart';
import 'views/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MMovie App",
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.from(colorScheme: const ColorScheme.dark()),
      themeMode: ThemeMode.dark,
      home: _auth.currentUser != null ? Feed() : Welcome(),
      routes: {
        'welcome_screen': (context) => Welcome(),
        'login_screen': (context) => Login(),
        'signup_screen': (context) => Signup(),
        'feed_screen': (context) => Feed(),
        'movie_detail_screen': (context) => MovieDetail(),
        'see_more_screen': (context) => SeeMore(),
      },
    );
  }
}

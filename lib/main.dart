import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mmovie/views/favorites.dart';
import 'package:mmovie/views/wishlist.dart';

import 'views/add_movie.dart';
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
      home: _auth.currentUser != null ? const Feed() : const Welcome(),
      routes: {
        'welcome_screen': (context) => const Welcome(),
        'login_screen': (context) => const Login(),
        'signup_screen': (context) => const Signup(),
        'feed_screen': (context) => const Feed(),
        'movie_detail_screen': (context) => const MovieDetail(),
        'see_more_screen': (context) => const SeeMore(),
        'add_movie_screen': (context) => const AddMovie(),
        'favorites_screen': (context) => const Favorites(),
        'wishlist_screen': (context) => const Wishlist(),
      },
    );
  }
}

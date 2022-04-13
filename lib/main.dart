import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'routes/routes.dart';
import 'views/feed.dart';
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
      routes: routes,
    );
  }
}

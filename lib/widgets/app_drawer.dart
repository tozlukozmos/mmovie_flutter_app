import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({Key? key}) : super(key: key);
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    void logout() async {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      await _auth.signOut();
      Navigator.pushReplacementNamed(context, 'welcome_screen');
    }

    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage:
                  NetworkImage(_auth.currentUser!.photoURL.toString()),
            ),
            accountName: const Text("Welcome,"),
            accountEmail: Text(_auth.currentUser!.email.toString()),
          ),
          ListTile(
            leading: const Icon(Icons.favorite_rounded),
            title: const Text("Favorites"),
            onTap: () {
              Navigator.pushNamed(context, "favorites_screen");
            },
          ),
          ListTile(
            leading: const Icon(Icons.bookmark_rounded),
            title: const Text("Wishlist"),
            onTap: () {
              Navigator.pushNamed(context, "wishlist_screen");
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_rounded),
            title: const Text("Settings"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.mail_rounded),
            title: const Text("Contact us"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info_rounded),
            title: const Text("About"),
            onTap: () {},
          ),
          ListTile(
            iconColor: Colors.redAccent,
            textColor: Colors.redAccent,
            leading: const Icon(Icons.logout),
            title: const Text("Log out"),
            onTap: logout,
          ),
        ],
      ),
    );
  }
}

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

    String avatar = _auth.currentUser!.photoURL.toString();
    avatar = avatar == "null"
        ? "https://firebasestorage.googleapis.com/v0/b/my-first-project-5d32d.appspot.com/o/1655305702422?alt=media&token=06613e76-266a-4877-85b6-23b6da92b4bd"
        : avatar;

    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.black),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(avatar),
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
          // ListTile(
          //   leading: const Icon(Icons.settings_rounded),
          //   title: const Text("Settings"),
          //   onTap: () {},
          // ),
          // ListTile(
          //   leading: const Icon(Icons.mail_rounded),
          //   title: const Text("Contact us"),
          //   onTap: () {},
          // ),
          ListTile(
            leading: const Icon(Icons.info_rounded),
            title: const Text("About"),
            onTap: () {
              Navigator.pushNamed(context, 'about_screen');
            },
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../widgets/app_buttons.dart';
import '../widgets/app_widgets.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Feed();
}

class _Feed extends State<Feed> {
  final _auth = FirebaseAuth.instance;
  final Query _moviesStream = FirebaseFirestore.instance.collection('movies');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Feed"),
        ),
        drawer: Drawer(
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
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.bookmark_rounded),
                title: const Text("Wishlist"),
                onTap: () {},
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
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Popular", style: TextStyle(fontSize: 20)),
                AppButtons.appTextButton(
                  name: "see more",
                  onPressed: () {
                    Navigator.pushNamed(context, 'see_more_screen', arguments: {
                      'title': 'Popular',
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 5),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: StreamBuilder(
                stream: _moviesStream
                    .where('rating', isGreaterThan: 80)
                    .orderBy('rating', descending: true)
                    .limit(15)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 300,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  } else {
                    return Row(
                      children: snapshot.data!.docs.map((e) {
                        Map<String, dynamic> movie =
                            e.data()! as Map<String, dynamic>;
                        return AppWidgets.movieCard(movie, context);
                      }).toList(),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Animation", style: TextStyle(fontSize: 20)),
                AppButtons.appTextButton(
                  name: "see more",
                  onPressed: () {
                    Navigator.pushNamed(context, 'see_more_screen', arguments: {
                      'title': 'Animation',
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 5),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: StreamBuilder(
                stream: _moviesStream
                    .where('categories', arrayContains: 'Animation')
                    .orderBy('rating', descending: true)
                    .limit(15)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 300,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  } else {
                    return Row(
                      children: snapshot.data!.docs.map((e) {
                        Map<String, dynamic> movie =
                            e.data()! as Map<String, dynamic>;
                        return AppWidgets.movieCard(movie, context);
                      }).toList(),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Comedy", style: TextStyle(fontSize: 20)),
                AppButtons.appTextButton(
                  name: "see more",
                  onPressed: () {
                    Navigator.pushNamed(context, 'see_more_screen', arguments: {
                      'title': 'Comedy',
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 5),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: StreamBuilder(
                stream: _moviesStream
                    .where('categories', arrayContains: 'Comedy')
                    .orderBy('rating', descending: true)
                    .limit(15)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 300,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  } else {
                    return Row(
                      children: snapshot.data!.docs.map((e) {
                        Map<String, dynamic> movie =
                            e.data()! as Map<String, dynamic>;
                        return AppWidgets.movieCard(movie, context);
                      }).toList(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, "add_movie_screen");
          },
        ),
      ),
    );
  }

  void logout() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, 'welcome_screen');
  }
}

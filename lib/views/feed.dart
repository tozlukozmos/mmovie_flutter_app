import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/app_buttons.dart';
import '../widgets/app_drawer.dart';
import '../widgets/app_hero_movie.dart';
import '../widgets/app_slider.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Feed();
}

class _Feed extends State<Feed> {
  final _auth = FirebaseAuth.instance;
  final _logs = FirebaseFirestore.instance.collection('logs');

  Map<String, dynamic> _userLog = {
    "user_id": 0,
    "movie_dataset": [],
    "watched": [],
    "created": 0,
  };

  Future<void> checkLogs() async {
    await _logs
        .doc(_auth.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      setState(() async {
        if (!documentSnapshot.exists) {
          _userLog = {
            "user_id": _auth.currentUser!.uid,
            "movie_dataset": [],
            "watched": [],
            "created": DateTime.now(),
          };
          await _logs
              .doc((_auth.currentUser!.uid))
              .set(_userLog)
              .then((value) => null)
              .catchError((error) => null);
        }
      });
    });
  }

  @override
  void initState() {
    checkLogs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Feed"),
          actions: [
            AppButtons.appIconButton(
              name: "search",
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.pushNamed(context, 'search_screen');
              },
            ),
          ],
        ),
        drawer: AppDrawer(),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const HeroMovie(),
            AppSlider.movieSlider(
              context: context,
              title: "Recently Added",
              isOrderByRating: false,
            ),
            AppSlider.movieSlider(
              context: context,
              title: "Popular",
              isOrderByRating: true,
            ),
            AppSlider.movieSlider(
              context: context,
              title: "Animation",
              isOrderByRating: true,
            ),
            AppSlider.movieSlider(
              context: context,
              title: "Science Fiction",
              isOrderByRating: false,
            ),
            AppSlider.movieSlider(
              context: context,
              title: "Drama",
              isOrderByRating: true,
            ),
            AppSlider.movieSlider(
              context: context,
              title: "Comedy",
              isOrderByRating: true,
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
}

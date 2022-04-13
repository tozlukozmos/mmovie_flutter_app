import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/app_buttons.dart';
import '../widgets/app_cards.dart';
import '../widgets/app_drawer.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Feed();
}

class _Feed extends State<Feed> {
  final Query _moviesStream = FirebaseFirestore.instance.collection('movies');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Feed")),
        drawer: AppDrawer(),
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
                        Map<String, dynamic> _movie = {"id": e.id, ...movie};
                        return AppCards.movieCard(
                          movie: _movie,
                          context: context,
                        );
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
                        Map<String, dynamic> _movie = {"id": e.id, ...movie};
                        return AppCards.movieCard(
                          movie: _movie,
                          context: context,
                        );
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
                        Map<String, dynamic> _movie = {"id": e.id, ...movie};
                        return AppCards.movieCard(
                          movie: _movie,
                          context: context,
                        );
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
}

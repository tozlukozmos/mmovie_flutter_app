import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/app_form.dart';
import '../widgets/app_widgets.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Favorites();
}

class _Favorites extends State<Favorites> {
  final _auth = FirebaseAuth.instance;
  final Query _moviesStream = FirebaseFirestore.instance.collection('movies');
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Favorites")),
        body: ListView(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: AppForm.appSearchField(
                hint: "Search among favorite movies...",
                controller: _searchController,
                onChanged: (String value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _moviesStream
                  .where(
                    'favorites',
                    arrayContains: _auth.currentUser!.uid,
                  )
                  .orderBy(
                    'rating',
                    descending: true,
                  )
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
                  //search algorithm
                  List movies = snapshot.data!.docs.map((doc) => doc).toList();
                  movies = movies
                      .where((s) => s['name']
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase()))
                      .toList();
                  return Column(
                    children: movies.map((e) {
                      Map<String, dynamic> movie =
                          e.data()! as Map<String, dynamic>;
                      Map<String, dynamic> _movie = {"id": e.id, ...movie};
                      return AppWidgets.movieCardMini(
                        _movie,
                        context,
                        _movie["id"],
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

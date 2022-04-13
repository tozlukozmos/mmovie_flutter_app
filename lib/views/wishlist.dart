import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/app_form.dart';
import '../widgets/app_cards.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Wishlist();
}

class _Wishlist extends State<Wishlist> {
  final _auth = FirebaseAuth.instance;
  final Query _moviesStream = FirebaseFirestore.instance.collection('movies');
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Wishlist")),
        body: ListView(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: AppForm.appSearchField(
                hint: "Search among wishlist movies...",
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
                    'wishlist',
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
                      return AppCards.movieCardMini(
                        movie: _movie,
                        context: context,
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

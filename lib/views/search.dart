import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/app_cards.dart';
import '../widgets/app_form.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Search();
}

class _Search extends State<Search> {
  final Query _moviesStream = FirebaseFirestore.instance.collection('movies');
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Search")),
        body: ListView(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: AppForm.appSearchField(
                hint: "Search by movie, cast or category name",
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
                  //List movies = snapshot.data!.docs.map((doc) => doc).toList();

                  List movies = [];
                  //List movies = snapshot.data!.docs.map((doc) => doc).toList();
                  for (var element in snapshot.data!.docs) {
                    if (!element.data().toString().contains('casts')) {
                      if (element['name']
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase()) ||
                          searchCategory(element["categories"], _searchQuery)) {
                        movies.add(element);
                      }
                    } else {
                      if (element['name']
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase()) ||
                          searchCategory(element["categories"], _searchQuery) ||
                          searchActor(element["casts"], _searchQuery)) {
                        movies.add(element);
                      }
                    }
                  }

                 // movies = movies
                   //   .where((s) => (s['name']
                     //         .toLowerCase()
                       //       .contains(_searchQuery.toLowerCase()) ||
                         // searchCategory(s["categories"], _searchQuery)))
                      //.toList();

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

  bool searchCategory(categories, searchQuery) {
    bool result = false;
    for (int i = 0; i < categories.length; i++) {
      if (categories[i].toLowerCase().contains(searchQuery.toLowerCase())) {
        result = true;
      }
    }
    return result;
  }

  bool searchActor(casts, searchQuery) {
    bool result = false;
    for (int i = 0; i < casts.length; i++) {
      if (casts[i]["fullname"]
          .toLowerCase()
          .contains(searchQuery.toLowerCase())) {
        result = true;
      }
    }
    return result;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/app_cards.dart';
import '../widgets/app_form.dart';

class CastMovies extends StatefulWidget {
  const CastMovies({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CastMovies();
}

class _CastMovies extends State<CastMovies> {
  final Query _moviesStream = FirebaseFirestore.instance.collection('movies');
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    final _cast = arg['cast'];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(_cast["fullname"])),
        body: ListView(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: AppForm.appSearchField(
                hint: "Search ${_cast["fullname"]} movies...",
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
                  List movies = [];
                  //List movies = snapshot.data!.docs.map((doc) => doc).toList();
                  for (var element in snapshot.data!.docs) {
                    if(element.data().toString().contains('casts')){
                      movies.add(element);
                    }
                  }
                  movies = movies
                      .where(
                          (s) => searchActor(s['casts'], _cast["fullname"]))
                      .toList();
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

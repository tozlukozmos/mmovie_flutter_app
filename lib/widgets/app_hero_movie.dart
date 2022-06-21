import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'app_cards.dart';

class HeroMovie extends StatefulWidget {
  const HeroMovie({Key? key}) : super(key: key);

  @override
  State<HeroMovie> createState() => _HeroMovie();
}

class _HeroMovie extends State<HeroMovie> {
  final _auth = FirebaseAuth.instance;

  Map<String, dynamic> heroMovie = {};
  bool isLoading = true;
  bool isWatched = false;

  Future<void> getMovieIds() async {
    final _logs = FirebaseFirestore.instance.collection('logs');
    await _logs.doc(_auth.currentUser!.uid).get().then((doc) {
      List movieIds = doc["movie_dataset"].toSet().toList();
      List watchedIds = doc["watched"];
      getMovieCategories(movieIds, watchedIds);
    });
  }

  Future<void> getMovieCategories(List movieIds, List watchedIds) async {
    final _movies = FirebaseFirestore.instance.collection('movies');
    List movieCategories = [];
    for (var movieId in movieIds) {
      await _movies.doc(movieId).get().then((doc) {
        movieCategories = [...movieCategories, ...doc["categories"]];
      });
    }
    getHeroMovie(countCategory(movieCategories), movieIds, watchedIds);
  }

  List countCategory(List categories) {
    List result = [];
    List uniqueCategories = categories.toSet().toList();
    for (var category in uniqueCategories) {
      result.add({
        "category": category,
        "amount": categories.where((e) => e == category).length,
      });
    }
    result.sort((a, b) => (b['amount']).compareTo(a['amount']));
    result = result.take(3).map((e) => e["category"]).toList();
    return result;
  }

  Future<void> getHeroMovie(List categories, List movieIds, List watchedIds) async {
    List movies = [];
    final _movies = FirebaseFirestore.instance.collection('movies');
    await _movies.get().then((QuerySnapshot querySnapshot) {
      if (movieIds.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          for (var category in doc["categories"]) {
            if (categories.contains(category) && !movieIds.contains(doc.id) && !watchedIds.contains(doc.id)) {
              Map<String, dynamic> movie = doc.data() as Map<String, dynamic>;
              Map<String, dynamic> _movie = {"id": doc.id, ...movie};
              movies.add(_movie);
            }
          }
        }
      } else {
        Map<String, dynamic> movie =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        Map<String, dynamic> _movie = {
          "id": querySnapshot.docs.first.id,
          ...movie
        };
        movies.add(_movie);
      }
    });
    movies.sort((a, b) => (b['rating']).compareTo(a['rating']));
    setState(() {
      heroMovie = movies[0];
      isLoading = false;
      isWatched = watchedIds.contains(heroMovie["id"]);
    });
  }

  @override
  void initState() {
    super.initState();
    getMovieIds();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 300,
            child: const Center(child: CircularProgressIndicator()),
          )
        : AppCards.movieHeroCard(
            movie: heroMovie,
            icon: isWatched ? Icon(
              Icons.remove_red_eye_sharp,
              color: Theme.of(context).secondaryHeaderColor,
            ) : Icon(
              Icons.remove_red_eye_outlined,
              color: Theme.of(context).secondaryHeaderColor,
            ),
            context: context,
            onPressed: () async {
              final _logs = FirebaseFirestore.instance.collection('logs');
              await _logs.doc(_auth.currentUser!.uid).get().then((doc) {
                List watchedIds = doc["watched"];
                if(watchedIds.contains(heroMovie["id"])){
                  watchedIds.remove(heroMovie["id"]);
                  setState(() {
                    isWatched = false;
                  });
                  _logs
                      .doc(_auth.currentUser!.uid)
                      .update({"watched": watchedIds})
                      .then((value) => null)
                      .catchError((error) => null);
                } else {
                  watchedIds.add(heroMovie["id"]);
                  setState(() {
                    isWatched = true;
                  });
                  _logs
                      .doc(_auth.currentUser!.uid)
                      .update({"watched": watchedIds})
                      .then((value) => null)
                      .catchError((error) => null);
                }
              });
            },
          );
  }
}

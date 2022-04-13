import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mmovie/widgets/app_buttons.dart';

class MovieDetail extends StatefulWidget {
  const MovieDetail({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MovieDetail();
}

class _MovieDetail extends State<MovieDetail> {
  final _auth = FirebaseAuth.instance;
  final CollectionReference _movies =
      FirebaseFirestore.instance.collection('movies');

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    final _movie = arg['movie'];

    bool _isFavorite = _movie["favorites"].contains(_auth.currentUser!.uid);
    bool _isWishlist = _movie["wishlist"].contains(_auth.currentUser!.uid);

    void favoriteFunction() async {
      if (_isFavorite) {
        _movie["favorites"].remove(_auth.currentUser!.uid);
        await _movies
            .doc(_movie["id"])
            .update({"favorites": _movie["favorites"]})
            .then((value) => {
                  setState(() {
                    _isFavorite = !_isFavorite;
                  }),
                })
            .catchError((error) => print("Failed to update movie: $error"));
      } else {
        _movie["favorites"].add(_auth.currentUser!.uid);
        await _movies
            .doc(_movie["id"])
            .update({"favorites": _movie["favorites"]})
            .then((value) => {
                  setState(() {
                    _isFavorite = !_isFavorite;
                  }),
                })
            .catchError((error) => print("Failed to update movie: $error"));
      }
    }

    void wishlistFunction() async {
      if (_isWishlist) {
        _movie["wishlist"].remove(_auth.currentUser!.uid);
        await _movies
            .doc(_movie["id"])
            .update({"wishlist": _movie["wishlist"]})
            .then((value) => {
                  setState(() {
                    _isWishlist = !_isWishlist;
                  }),
                })
            .catchError((error) => print("Failed to update movie: $error"));
      } else {
        _movie["wishlist"].add(_auth.currentUser!.uid);
        await _movies
            .doc(_movie["id"])
            .update({"wishlist": _movie["wishlist"]})
            .then((value) => {
                  setState(() {
                    _isWishlist = !_isWishlist;
                  }),
                })
            .catchError((error) => print("Failed to update movie: $error"));
      }
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Details")),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: Text(
                _movie['name'],
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      _movie['image'],
                      width: 200,
                      height: 300,
                    ),
                  ),
                  Positioned(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      child: Text(_movie['year'].toString()),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: -18,
                    bottom: -18,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Theme.of(context).colorScheme.background,
                      ),
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          CircularProgressIndicator(
                            color: getRatingColor(_movie['rating'] / 100),
                            value: _movie['rating'] / 100,
                          ),
                          Positioned.fill(
                            child:
                                Align(child: Text(_movie['rating'].toString())),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Center(child: Text(getCategories(_movie['categories']))),
            const SizedBox(height: 30),
            AppButtons.appOutlinedButtonIcon(
              name: _isFavorite ? "Remove from favorites" : "Add to favorites",
              icon: _isFavorite
                  ? const Icon(Icons.favorite_rounded)
                  : const Icon(Icons.favorite_border_rounded),
              onPressed: favoriteFunction,
            ),
            AppButtons.appOutlinedButtonIcon(
              name: _isWishlist ? "Remove from wishlist" : "Add to wishlist",
              icon: _isWishlist
                  ? const Icon(Icons.bookmark_rounded)
                  : const Icon(Icons.bookmark_outline_rounded),
              onPressed: wishlistFunction,
            ),
            const SizedBox(height: 30),
            const Text("Description", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            Text(_movie['description']),
          ],
        ),
      ),
    );
  }

  String getCategories(List array) {
    String result = "";
    for (int index = 0; index < array.length; index++) {
      if (index == array.length - 1) {
        result += array[index];
      } else {
        result += array[index] + ", ";
      }
    }
    return result;
  }

  Color getRatingColor(number) {
    if (number >= 0.8) {
      return Colors.green;
    } else if (number >= 0.5) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }
}

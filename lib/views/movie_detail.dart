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
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                _movie['image'],
                width: 350,
                height: 500,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_month_rounded),
                    const SizedBox(width: 5),
                    Text(_movie["year"].toString()),
                  ],
                ),
                const SizedBox(width: 20),
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded),
                    const SizedBox(width: 5),
                    Text(getDuration(_movie["runtime"])),
                  ],
                ),
                const SizedBox(width: 20),
                Row(
                  children: [
                    Icon(
                      Icons.star_outline_rounded,
                      color: getRatingColor(_movie["rating"]),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      (_movie["rating"] / 10).toString(),
                      style: TextStyle(color: getRatingColor(_movie["rating"])),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
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
            Text(_movie['description'], style: const TextStyle(height: 1.5)),
            const SizedBox(height: 30),
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

  String getDuration(int minutes) {
    int hour = 0, minute = 0;
    minute = minutes % 60;
    hour = (minutes - minutes % 60) ~/ 60;
    return "$hour h $minute m";
  }

  Color getRatingColor(number) {
    if (number >= 70) {
      return Colors.green;
    } else if (number >= 50) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }
}

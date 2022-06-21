// import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mmovie/widgets/app_cards.dart';

// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../widgets/app_buttons.dart';

class MovieDetail extends StatefulWidget {
  const MovieDetail({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MovieDetail();
}

class _MovieDetail extends State<MovieDetail> {
  final _auth = FirebaseAuth.instance;
  final _movies = FirebaseFirestore.instance.collection('movies');
  final _logs = FirebaseFirestore.instance.collection('logs');

  // Map cast = {
  //   'fullname': "Leonardo DiCaprio",
  //   'movie-name': "Dom Cobb",
  //   'image':
  //       "https://image.tmdb.org//t/p/w276_and_h350_face/wo2hJpn04vbtmh0B9utCFdsQhxM.jpg",
  // };

  // List casts = [];

  List admins = [];
  List movieDataset = [];

  Future<void> getAdmins() async {
    final _admins = FirebaseFirestore.instance.collection('admins');
    await _admins.get().then((QuerySnapshot querySnapshot) {
      setState(() {
        for (var doc in querySnapshot.docs) {
          admins.add(doc["email"]);
        }
      });
    });
  }

  Future<void> getMovieDataset() async {
    await _logs.get().then((QuerySnapshot querySnapshot) {
      setState(() {
        for (var doc in querySnapshot.docs) {
          if (doc["user_id"] == _auth.currentUser!.uid) {
            movieDataset = doc["movie_dataset"];
          }
        }
      });
    });
  }

  @override
  void initState() {
    getAdmins();
    getMovieDataset();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    final _movie = arg['movie'];
    final String url = _movie['trailer'];
    List casts = _movie["casts"] ?? [];

    String userEmail = _auth.currentUser!.email.toString();

    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(url) ?? "q8LqhYtJzP0",
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );

    bool _isFavorite = _movie["favorites"].contains(_auth.currentUser!.uid);
    bool _isWishlist = _movie["wishlist"].contains(_auth.currentUser!.uid);

    void favoriteFunction() async {
      if (_isFavorite) {
        _movie["favorites"].remove(_auth.currentUser!.uid);
        await _movies
            .doc(_movie["id"])
            .update({"favorites": _movie["favorites"]})
            .then((value) async => {
                  if (movieDataset.contains(_movie["id"]))
                    {
                      movieDataset.remove(_movie["id"]),
                    },
                  await _logs
                      .doc(_auth.currentUser!.uid)
                      .update({"movie_dataset": movieDataset})
                      .then((value) => null)
                      .catchError((error) => null),
                  setState(() {
                    _isFavorite = !_isFavorite;
                  }),
                })
            .catchError(
              (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Failed to update movie: $error"),
                    duration: const Duration(milliseconds: 1500),
                  ),
                );
              },
            );
      } else {
        _movie["favorites"].add(_auth.currentUser!.uid);
        await _movies
            .doc(_movie["id"])
            .update({"favorites": _movie["favorites"]})
            .then((value) async => {
                  movieDataset.add(_movie["id"]),
                  await _logs
                      .doc(_auth.currentUser!.uid)
                      .update({"movie_dataset": movieDataset})
                      .then((value) => null)
                      .catchError((error) => null),
                  setState(() {
                    _isFavorite = !_isFavorite;
                  }),
                })
            .catchError(
              (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Failed to update movie: $error"),
                    duration: const Duration(milliseconds: 1500),
                  ),
                );
              },
            );
      }
    }

    void wishlistFunction() async {
      if (_isWishlist) {
        _movie["wishlist"].remove(_auth.currentUser!.uid);
        await _movies
            .doc(_movie["id"])
            .update({"wishlist": _movie["wishlist"]})
            .then((value) async => {
                  if (movieDataset.contains(_movie["id"]))
                    {
                      movieDataset.remove(_movie["id"]),
                    },
                  await _logs
                      .doc(_auth.currentUser!.uid)
                      .update({"movie_dataset": movieDataset})
                      .then((value) => null)
                      .catchError((error) => null),
                  setState(() {
                    _isWishlist = !_isWishlist;
                  }),
                })
            .catchError(
              (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Failed to update movie: $error"),
                    duration: const Duration(milliseconds: 1500),
                  ),
                );
              },
            );
      } else {
        _movie["wishlist"].add(_auth.currentUser!.uid);
        await _movies
            .doc(_movie["id"])
            .update({"wishlist": _movie["wishlist"]})
            .then((value) async => {
                  movieDataset.add(_movie["id"]),
                  await _logs
                      .doc(_auth.currentUser!.uid)
                      .update({"movie_dataset": movieDataset})
                      .then((value) => null)
                      .catchError((error) => null),
                  setState(() {
                    _isWishlist = !_isWishlist;
                  }),
                })
            .catchError(
              (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Failed to update movie: $error"),
                    duration: const Duration(milliseconds: 1500),
                  ),
                );
              },
            );
      }
    }

    void shareMovie() async {
      // final box = context.findRenderObject() as RenderBox?;
      String title = _movie["name"] +
          " (" +
          _movie["year"].toString() +
          ") " +
          "IMDB: " +
          (_movie["rating"] / 10).toString();
      // final url = Uri.parse(_movie["image"]);
      // final response = await http.get(url);
      // final bytes = response.bodyBytes;

      // final temp = await getTemporaryDirectory();
      // final path = '${temp.path}/image.jpg';
      // File(path).writeAsBytesSync(bytes);

      await Share.share(_movie["trailer"] + " " + title);

      // await Share.shareFiles([path],
      //     text: _movie["trailer"] + " " + title,
      //     sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    }

    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blue,
      ),
      builder: (context, player) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Details"),
            actions: [
              admins.contains(userEmail)
                  ? AppButtons.appIconButton(
                      name: 'movie_edit',
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.pushNamed(context, 'edit_movie_screen',
                            arguments: {'movie': _movie});
                      },
                    )
                  : const Text(""),
              AppButtons.appIconButton(
                name: "share_movie",
                icon: const Icon(Icons.share),
                onPressed: shareMovie,
              )
            ],
          ),
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
              AspectRatio(
                aspectRatio: 2 / 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    _movie['image'],
                    width: double.infinity,
                  ),
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
                      const Icon(Icons.star_rate_rounded),
                      const SizedBox(width: 5),
                      Text((_movie["rating"] / 10).toString()),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(child: Text(getCategories(_movie['categories']))),
              const SizedBox(height: 30),
              AppButtons.appElevatedButtonIcon(
                name:
                    _isFavorite ? "Remove from favorites" : "Add to favorites",
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
              if (casts.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Top Casts", style: TextStyle(fontSize: 20)),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 225,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: casts.length,
                        itemBuilder: (context, index) {
                          return AppCards.castCard(
                              cast: casts[index], context: context);
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              const Text('Trailer', style: TextStyle(fontSize: 20)),
              const SizedBox(height: 30),
              player,
            ],
          ),
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
    if (minute == 0) {
      return "$hour h";
    } else {
      return "$hour h $minute m";
    }
  }
}

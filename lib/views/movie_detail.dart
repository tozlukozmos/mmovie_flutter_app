import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mmovie/widgets/app_buttons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieDetail extends StatefulWidget {
  const MovieDetail({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MovieDetail();
}

class _MovieDetail extends State<MovieDetail> {
  late String url;

  final _auth = FirebaseAuth.instance;
  final CollectionReference _movies =
      FirebaseFirestore.instance.collection('movies');

  List<String> admins = [
    "furkan@gmail.com",
    "omer@gmail.com",
    "abdulkadir@gmail.com"
  ];

  bool checkUser() {
    String user = _auth.currentUser!.email.toString();

    if (admins.contains(user)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    final _movie = arg['movie'];
    url = _movie['trailer'];

    // YoutubePlayerController _controller = YoutubePlayerController(
    //     initialVideoId: YoutubePlayer.convertUrlToId(url)!,
    //     flags: YoutubePlayerFlags(
    //       autoPlay: false,
    //       mute: false,
    //     ));

    bool _isFavorite = _movie["favorites"].contains(_auth.currentUser!.uid);
    bool _isWishlist = _movie["wishlist"].contains(_auth.currentUser!.uid);

    Widget editButton() {
      return AppButtons.appIconButton(
          name: 'movie_edit',
          icon: Icon(Icons.edit),
          onPressed: () {
            Navigator.pushNamed(context, 'edit_movie_screen',
                arguments: {'movie': _movie});
          });
    }

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
        appBar: AppBar(
          title: const Text("Details"),
          actions: [
            checkUser() ? editButton() : Text(''),
            AppButtons.appIconButton(
              name: "share_movie",
              icon: const Icon(Icons.share),
              onPressed: () async {
                final box = context.findRenderObject() as RenderBox?;
                String title = _movie["name"] +
                    " (" +
                    _movie["year"].toString() +
                    ") " +
                    "IMDB: " +
                    (_movie["rating"] / 10).toString();
                final url = Uri.parse(_movie["image"]);
                final response = await http.get(url);
                final bytes = response.bodyBytes;

                final temp = await getTemporaryDirectory();
                final path = '${temp.path}/image.jpg';
                File(path).writeAsBytesSync(bytes);

                await Share.shareFiles([path],
                    text: title,
                    sharePositionOrigin:
                        box!.localToGlobal(Offset.zero) & box.size);
              },
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
            Text('Trailer', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 30),
            // YoutubePlayer(
            //   controller: _controller,
            //   showVideoProgressIndicator: true,
            //   progressIndicatorColor: Colors.blue,
            // )
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
    if (minute == 0) {
      return "$hour h";
    } else {
      return "$hour h $minute m";
    }
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

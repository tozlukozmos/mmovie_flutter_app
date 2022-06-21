import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:mmovie/widgets/app_alerts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/app_buttons.dart';
import '../widgets/app_form.dart';

class AddMovie extends StatefulWidget {
  const AddMovie({Key? key}) : super(key: key);

  @override
  State<AddMovie> createState() => _AddMovie();
}

class _AddMovie extends State<AddMovie> {
  final _auth = FirebaseAuth.instance;
  final _movies = FirebaseFirestore.instance.collection('movies');
  final _logs = FirebaseFirestore.instance.collection('logs');

  final _formKey = GlobalKey<FormState>();
  final _formURLKey = GlobalKey<FormState>();

  // ignore: non_constant_identifier_names
  final TextEditingController _TMDMovieURLController = TextEditingController();
  final TextEditingController _movieNameController = TextEditingController();
  final TextEditingController _releaseYearController = TextEditingController();
  final TextEditingController _imdbRatingController = TextEditingController();
  final TextEditingController _runtimeController = TextEditingController();
  final TextEditingController _categoriesController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _trailerController = TextEditingController();

  List movieDataset = [];

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

  Map<String, dynamic> _newMovie = {
    "name": "",
    "year": 0,
    "rating": 0,
    "runtime": 0,
    "categories": [],
    "favorites": [],
    "wishlist": [],
    "casts": [],
    "description": "",
    "image": "",
    "trailer": "",
  };

  Map<String, dynamic> _newMovieCast = {
    "fullname": "",
    "actor-name": "",
    "image": "",
  };

  @override
  void initState() {
    getMovieDataset();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Add movie"),
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.link),
                  text: "TMDB Movie URL",
                ),
                Tab(
                  icon: Icon(Icons.link_off),
                  text: "Movie Details",
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Form(
                key: _formURLKey,
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    AppForm.appTextFormField(
                      label: "TMDB Movie URL",
                      controller: _TMDMovieURLController,
                    ),
                    const SizedBox(height: 20),
                    AppForm.appTextFormField(
                      label: "IMDB Rating (a decimal between 0 and 100)",
                      controller: _imdbRatingController,
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        Expanded(
                          child: AppButtons.appElevatedButtonIcon(
                            icon: const Icon(Icons.add),
                            name: "Add movie",
                            onPressed: addMovieWithURL,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "What is TMDB Movie URL?",
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "It is a website for movie data. You should go to the website and search which movie you want to add. Then, you should copy movie profile link which is the current page URL. That's it!",
                      style: TextStyle(height: 1.5),
                    ),
                    const SizedBox(height: 20),
                    AppButtons.appOutlinedButtonIcon(
                      name: "Go to TMDB Website",
                      icon: const Icon(Icons.link),
                      onPressed: () async {
                        final Uri _url =
                            Uri.parse('https://www.themoviedb.org/');
                        if (!await launchUrl(
                          _url,
                          mode: LaunchMode.externalApplication,
                        )) {
                          throw ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              padding: const EdgeInsets.all(0),
                              content: AppAlerts.appAlert(
                                title: "Could not launch $_url",
                                color: Colors.red,
                                icon: const Icon(Icons.clear),
                              ),
                              duration: const Duration(milliseconds: 1500),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "What is IMDB Rating?",
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "It is a website for evaluating the popularity of any movie. Therefore, we want you to add this score to help others, how the movie is good you added. For that, you can go to IMDB website and search which movie you want to add. Then add this score here. That's it!",
                      style: TextStyle(height: 1.5),
                    ),
                    const SizedBox(height: 20),
                    AppButtons.appOutlinedButtonIcon(
                      name: "Go to IMDB Website",
                      icon: const Icon(Icons.link),
                      onPressed: () async {
                        final Uri _url = Uri.parse('https://www.imdb.com/');
                        if (!await launchUrl(_url)) {
                          throw ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              padding: const EdgeInsets.all(0),
                              content: AppAlerts.appAlert(
                                title: "Could not launch $_url",
                                color: Colors.red,
                                icon: const Icon(Icons.clear),
                              ),
                              duration: const Duration(milliseconds: 1500),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    AppForm.appTextFormField(
                      label: "Movie Name",
                      controller: _movieNameController,
                    ),
                    const SizedBox(height: 20),
                    AppForm.appTextFormField(
                      label: "Release Year",
                      controller: _releaseYearController,
                    ),
                    const SizedBox(height: 20),
                    AppForm.appTextFormField(
                      label: "IMDB Rating",
                      controller: _imdbRatingController,
                    ),
                    const SizedBox(height: 20),
                    AppForm.appTextFormField(
                      label: "Runtime (in terms of minute)",
                      controller: _runtimeController,
                    ),
                    const SizedBox(height: 20),
                    AppForm.appTextFormField(
                      label: "Categories (use comma to separate them)",
                      controller: _categoriesController,
                    ),
                    const SizedBox(height: 20),
                    AppForm.appTextFormField(
                      label: "Description",
                      controller: _descriptionController,
                    ),
                    const SizedBox(height: 20),
                    AppForm.appTextFormField(
                      label: "Image URL",
                      controller: _imageController,
                    ),
                    const SizedBox(height: 20),
                    AppForm.appTextFormField(
                      label: "Trailer URL",
                      controller: _trailerController,
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        Expanded(
                          child: AppButtons.appElevatedButtonIcon(
                            icon: const Icon(Icons.add),
                            name: "Add movie",
                            onPressed: addMovie,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addMovie() async {
    try {
      if (_formKey.currentState!.validate()) {
        _newMovie = {
          "name": _movieNameController.text,
          "year": int.parse(_releaseYearController.text),
          "rating": int.parse(_imdbRatingController.text),
          "runtime": int.parse(_runtimeController.text),
          "categories": _categoriesController.text
              .split(",")
              .map((e) => e.trim())
              .toList(),
          "favorites": [],
          "wishlist": [],
          "description": _descriptionController.text,
          "image": _imageController.text,
          "trailer": _trailerController.text,
          "created": DateTime.now(),
        };
        await _movies
            .add(_newMovie)
            .then(
              (value) async => {
                movieDataset.add(_movies.doc().id),
                await _logs
                    .doc(_auth.currentUser!.uid)
                    .update({"movie_dataset": movieDataset})
                    .then((value) => null)
                    .catchError((error) => null),
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    padding: const EdgeInsets.all(0),
                    content: AppAlerts.appAlert(
                      title: "Movie added successfully",
                      color: Colors.green,
                      icon: const Icon(Icons.check),
                    ),
                    duration: const Duration(milliseconds: 1500),
                  ),
                ),
                Navigator.pushReplacementNamed(context, "feed_screen"),
              },
            )
            .catchError(
              (error) => {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    padding: const EdgeInsets.all(0),
                    content: AppAlerts.appAlert(
                      title: error.toString(),
                      color: Colors.red,
                      icon: const Icon(Icons.clear),
                    ),
                    duration: const Duration(milliseconds: 1500),
                  ),
                ),
              },
            );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          padding: const EdgeInsets.all(0),
          content: AppAlerts.appAlert(
            title: e.toString(),
            color: Colors.red,
            icon: const Icon(Icons.clear),
          ),
          duration: const Duration(milliseconds: 1500),
        ),
      );
    }
  }

  void addMovieWithURL() async {
    try {
      if (_formURLKey.currentState!.validate()) {
        Uri url = Uri.parse(_TMDMovieURLController.text);
        List casts = [];

        var res = await http.get(url);
        final body = res.body;
        final document = parser.parse(body);
        var responseMovies = document.getElementById("original_header");
        var responseCasts = document.getElementsByClassName("white_column");

        String? imageMovie = responseMovies!.children[0].children[0].children[0]
            .children[0].attributes['data-srcset'];
        imageMovie = imageMovie!
            .substring(
                imageMovie.indexOf(",") + 1, imageMovie.indexOf("2x") - 1)
            .trim();
        var _casts =
            responseCasts[0].children[0].children[1].children[0].children;

        for (int i = 0; i < _casts.length - 1; i++) {
          String? imageCast =
              _casts[i].children[0].children[0].attributes["srcset"];
          imageCast = imageCast == null
              ? "https://firebasestorage.googleapis.com/v0/b/my-first-project-5d32d.appspot.com/o/1655306121671?alt=media&token=ceb6af74-99ef-457d-bae8-58211853fb55"
              : 'https://image.tmdb.org/' +
                  imageCast
                      .substring(imageCast.indexOf(",") + 1,
                          imageCast.indexOf("2x") - 1)
                      .trim();
          // print(imageCast);
          _newMovieCast = {
            'image': imageCast,
            'fullname': _casts[i].children[1].text,
            'actor-name': _casts[i].children[2].text,
          };
          casts.add(_newMovieCast);
        }

        /* print("name: " +
          responseMovies.children[1].children[0].children[0].children[0]
               .children[0].text);
         print("year: " +
             responseMovies.children[1].children[0].children[0].children[0].children[1]
                 .text
                 .substring(1, 5));*/
        // print("rating: " + _imdbRatingController.text);
        // print("runtime: 180");

        var categories = responseMovies
            .children[1].children[0].children[0].children[1].children.length;
        List<String> _categories = categories < 4
            ? responseMovies.children[1].children[0].children[0].children[1]
                .children[1].children
                .map((e) => e.text)
                .toList()
            : responseMovies.children[1].children[0].children[0].children[1]
                .children[2].children
                .map((e) => e.text)
                .toList();

        var description =
            responseMovies.children[1].children[0].children[2].children.length;
        String _description = description < 4
            ? responseMovies.children[1].children[0].children[2].children[1]
                .children[0].text
            : responseMovies.children[1].children[0].children[2].children[2]
                .children[0].text;

        //print(_categories.toString());
        //print(_description);

        // print("image: " +
        //     'https://image.tmdb.org/' +
        //     image!
        //         .substring(image.indexOf(",") + 1, image.indexOf("2x") - 1)
        //         .trim());
        // print("trailer: " +
        //     'https://www.youtube.com/watch?v=' +
        //     responseMovies.children[1].children[0].children[1].children[5].children[0]
        //         .attributes["data-id"]
        //         .toString());

        var trailer =
            responseMovies.children[1].children[0].children[1].children.length;
        String _trailer = trailer < 6
            ? "q8LqhYtJzP0"
            : responseMovies.children[1].children[0].children[1].children[5]
                .children[0].attributes["data-id"]
                .toString();
        var runtime = responseMovies
            .children[1].children[0].children[0].children[1].children.length;
        String _runtime = runtime < 4
            ? responseMovies.children[1].children[0].children[0].children[1]
                .children[2].text
                .trim()
            : responseMovies.children[1].children[0].children[0].children[1]
                .children[3].text
                .trim();

        _newMovie = {
          "name": responseMovies
              .children[1].children[0].children[0].children[0].children[0].text,
          "year": int.parse(responseMovies
              .children[1].children[0].children[0].children[0].children[1].text
              .substring(1, 5)),
          "rating": int.parse(_imdbRatingController.text),
          "runtime": convertToMinutes(_runtime),
          "categories": _categories,
          "favorites": [],
          "wishlist": [],
          "description": _description,
          "image": 'https://image.tmdb.org/' + imageMovie,
          "trailer": 'https://www.youtube.com/watch?v=' + _trailer,
          "casts": casts,
          "created": DateTime.now(),
        };
        await _movies
            .add(_newMovie)
            .then(
              (value) async => {
                movieDataset.add(_movies.doc().id),
                await _logs
                    .doc(_auth.currentUser!.uid)
                    .update({"movie_dataset": movieDataset})
                    .then((value) => null)
                    .catchError((error) => null),
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    padding: const EdgeInsets.all(0),
                    content: AppAlerts.appAlert(
                      title: "Movie added successfully",
                      color: Colors.green,
                      icon: const Icon(Icons.check),
                    ),
                    duration: const Duration(milliseconds: 1500),
                  ),
                ),
                Navigator.pushReplacementNamed(context, "feed_screen"),
              },
            )
            .catchError(
              (error) => {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    padding: const EdgeInsets.all(0),
                    content: AppAlerts.appAlert(
                      title: error.toString(),
                      color: Colors.red,
                      icon: const Icon(Icons.clear),
                    ),
                    duration: const Duration(milliseconds: 1500),
                  ),
                ),
              },
            );
      }
    } catch (e) {
      if (e.toString().contains("No host")) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            padding: const EdgeInsets.all(0),
            content: AppAlerts.appAlert(
              title: "Invalid TMDB movie URL",
              color: Colors.red,
              icon: const Icon(Icons.clear),
            ),
            duration: const Duration(milliseconds: 1500),
          ),
        );
      } else if (e.toString().contains("radix-10 number")) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            padding: const EdgeInsets.all(0),
            content: AppAlerts.appAlert(
              title: "IMDB rating can be only decimal",
              color: Colors.red,
              icon: const Icon(Icons.clear),
            ),
            duration: const Duration(milliseconds: 1500),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            padding: const EdgeInsets.all(0),
            content: AppAlerts.appAlert(
              title: e.toString(),
              color: Colors.red,
              icon: const Icon(Icons.clear),
            ),
            duration: const Duration(milliseconds: 1500),
          ),
        );
      }
    }
  }

  int convertToMinutes(String runtime) {
    int hour = 0;
    int minutes = 0;

    if (runtime.contains("m") && !runtime.contains("h")) {
      minutes = int.parse(runtime.substring(0, runtime.indexOf("m")));
    } else if (!runtime.contains("m") && runtime.contains("h")) {
      hour = int.parse(runtime.substring(0, runtime.indexOf("h")));
    } else {
      hour = int.parse(runtime.substring(0, runtime.indexOf("h")));
      minutes = int.parse(
          runtime.substring(runtime.indexOf("h") + 1, runtime.indexOf("m")));
    }

    int result = hour * 60 + minutes;
    return result;
  }

  @override
  void dispose() {
    _movieNameController.dispose();
    _releaseYearController.dispose();
    _imdbRatingController.dispose();
    _categoriesController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
    _trailerController.dispose();
    super.dispose();
  }
}

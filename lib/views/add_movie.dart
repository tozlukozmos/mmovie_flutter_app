import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

import '../widgets/app_buttons.dart';
import '../widgets/app_form.dart';

class AddMovie extends StatefulWidget {
  const AddMovie({Key? key}) : super(key: key);

  @override
  State<AddMovie> createState() => _AddMovie();
}

class _AddMovie extends State<AddMovie> {
  final CollectionReference _movies =
      FirebaseFirestore.instance.collection('movies');

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
                      label: "IMDB Rating",
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
              (value) => {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Movie added successfully'),
                    duration: Duration(milliseconds: 1500),
                  ),
                ),
                Navigator.pushReplacementNamed(context, "feed_screen"),
              },
            )
            .catchError(
              (error) => {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(error.toString()),
                    duration: const Duration(milliseconds: 1500),
                  ),
                ),
              },
            );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
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
        var _casts =
            responseCasts[0].children[0].children[1].children[0].children;

        for (int i = 0; i < _casts.length - 1; i++) {
          String? imageCast =
              _casts[i].children[0].children[0].attributes["srcset"];
          _newMovieCast = {
            'image': 'https://image.tmdb.org/' +
                imageCast!
                    .substring(
                        imageCast.indexOf(",") + 1, imageCast.indexOf("2x") - 1)
                    .trim(),
            'fullname': _casts[i].children[1].text,
            'actor-name': _casts[i].children[2].text,
          };
          casts.add(_newMovieCast);
        }

        // print("name: " +
        //     response.children[1].children[0].children[0].children[0].children[0]
        //         .text);
        // print("year: " +
        //     response.children[1].children[0].children[0].children[0].children[1]
        //         .text
        //         .substring(1, 5));
        // print("rating: " + _imdbRatingController.text);
        // print("runtime: 180");

        // print("categories: " +
        //     response.children[1].children[0].children[0].children[1].children[2]
        //         .children
        //         .map((e) => e.text)
        //         .toList()
        //         .toString());

        // print("description: " +
        //     response.children[1].children[0].children[2].children[2].children[0]
        //         .text);
        // print("image: " +
        //     'https://image.tmdb.org/' +
        //     image!
        //         .substring(image.indexOf(",") + 1, image.indexOf("2x") - 1)
        //         .trim());
        // print("trailer: " +
        //     'https://www.youtube.com/watch?v=' +
        //     response.children[1].children[0].children[1].children[5].children[0]
        //         .attributes["data-id"]
        //         .toString());

        _newMovie = {
          "name": responseMovies
              .children[1].children[0].children[0].children[0].children[0].text,
          "year": int.parse(responseMovies
              .children[1].children[0].children[0].children[0].children[1].text
              .substring(1, 5)),
          "rating": int.parse(_imdbRatingController.text),
          "runtime": convertToMinutes(responseMovies
              .children[1].children[0].children[0].children[1].children[3].text
              .trim()),
          "categories": responseMovies.children[1].children[0].children[0]
              .children[1].children[2].children
              .map((e) => e.text)
              .toList(),
          "favorites": [],
          "wishlist": [],
          "description": responseMovies
              .children[1].children[0].children[2].children[2].children[0].text,
          "image": 'https://image.tmdb.org/' +
              imageMovie!
                  .substring(
                      imageMovie.indexOf(",") + 1, imageMovie.indexOf("2x") - 1)
                  .trim(),
          "trailer": 'https://www.youtube.com/watch?v=' +
              responseMovies.children[1].children[0].children[1].children[5]
                  .children[0].attributes["data-id"]
                  .toString(),
          "casts": casts,
          "created": DateTime.now(),
        };
        await _movies
            .add(_newMovie)
            .then(
              (value) => {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Movie added successfully'),
                    duration: Duration(milliseconds: 1500),
                  ),
                ),
                Navigator.pushReplacementNamed(context, "feed_screen"),
              },
            )
            .catchError(
              (error) => {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("world" + error.toString()),
                    duration: const Duration(milliseconds: 1500),
                  ),
                ),
              },
            );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("hello" + e.toString()),
          duration: const Duration(milliseconds: 1500),
        ),
      );
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

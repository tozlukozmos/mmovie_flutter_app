import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
  final TextEditingController _movieNameController = TextEditingController();
  final TextEditingController _releaseYearController = TextEditingController();
  final TextEditingController _imdbRatingController = TextEditingController();
  final TextEditingController _runtimeController = TextEditingController();
  final TextEditingController _categoriesController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  Map<String, dynamic> _newMovie = {
    "name": "",
    "year": 0,
    "rating": 0,
    "runtime": 0,
    "categories": [],
    "favorites": [],
    "wishlist": [],
    "description": "",
    "image": "",
  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Add movie")),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              AppForm.appTextFormField(
                label: "Movie name",
                controller: _movieNameController,
              ),
              const SizedBox(height: 20),
              AppForm.appTextFormField(
                label: "Release year",
                controller: _releaseYearController,
              ),
              const SizedBox(height: 20),
              AppForm.appTextFormField(
                label: "IMDB rating",
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
          "categories":
              _categoriesController.text.split(",").map((e) => e.trim()).toList(),
          "favorites": [],
          "wishlist": [],
          "description": _descriptionController.text,
          "image": _imageController.text,
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

  @override
  void dispose() {
    _movieNameController.dispose();
    _releaseYearController.dispose();
    _imdbRatingController.dispose();
    _categoriesController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
    super.dispose();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/app_buttons.dart';
import '../widgets/app_form.dart';

class EditMovie extends StatelessWidget {
  EditMovie({Key? key}) : super(key: key);

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
  final TextEditingController _trailerController = TextEditingController();

  Map<String, dynamic> _updatedMovie = {
    "name": "",
    "year": 0,
    "rating": 0,
    "runtime": 0,
    "categories": [],
    "description": "",
    "image": "",
    "trailer": "",
  };

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    final movie = arg['movie'];

    _movieNameController.text = movie["name"];
    _releaseYearController.text = movie["year"].toString();
    _imdbRatingController.text = movie["rating"].toString();
    _runtimeController.text = movie["runtime"].toString();
    _categoriesController.text = getCategories(movie["categories"]);
    _descriptionController.text = movie["description"];
    _imageController.text = movie["image"];
    _trailerController.text = movie["trailer"];

    void editMovie() async {
      try {
        if (_formKey.currentState!.validate()) {
          _updatedMovie = {
            "name": _movieNameController.text,
            "year": int.parse(_releaseYearController.text),
            "rating": int.parse(_imdbRatingController.text),
            "runtime": int.parse(_runtimeController.text),
            "categories": _categoriesController.text
                .split(",")
                .map((e) => e.trim())
                .toList(),
            "description": _descriptionController.text,
            "image": _imageController.text,
            "trailer": _trailerController.text,
          };
          await _movies
              .doc(movie["id"])
              .update(_updatedMovie)
              .then(
                (value) => {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Movie edited successfully'),
                      duration: Duration(milliseconds: 1500),
                    ),
                  ),
                  Navigator.pushNamed(context, "feed_screen"),
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

    void deleteMovie() async {
      try {
        await _movies
            .doc(movie["id"])
            .delete()
            .then(
              (value) => {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Movie deleted successfully'),
                    duration: Duration(milliseconds: 1500),
                  ),
                ),
                Navigator.pushNamed(context, "feed_screen"),
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
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            duration: const Duration(milliseconds: 1500),
          ),
        );
      }
    }

    void showMessage() async {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Are you sure for deleting?"),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              AppButtons.appOutlinedButton(
                name: "Yes, delete",
                onPressed: deleteMovie,
              ),
              AppButtons.appElevatedButton(
                name: "No, don't delete",
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        },
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Edit Movie"),
          actions: [
            AppButtons.appIconButton(
              name: 'delete_button',
              icon: const Icon(Icons.delete),
              onPressed: showMessage,
            )
          ],
        ),
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
                      icon: const Icon(Icons.edit),
                      name: "Edit Movie",
                      onPressed: editMovie,
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
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/app_buttons.dart';
import '../widgets/app_form.dart';

class edit_movie extends StatelessWidget {
  edit_movie({Key? key, required this.movie}) : super(key: key);
  final Map movie;

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

  @override
  Widget build(BuildContext context) {
    _movieNameController.text = movie["name"];
    _releaseYearController.text = movie["year"].toString();
    _imdbRatingController.text = movie["rating"].toString();
    _runtimeController.text = movie["runtime"].toString();
    _categoriesController.text = getCategories(movie["categories"]);
    _descriptionController.text = movie["description"];
    _imageController.text = movie["image"];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Edit Movie"),
          actions: [
            AppButtons.appIconButton(
              name: 'delete buton',
              icon: Icon(Icons.delete),
              onPressed: () async {
                CollectionReference users =
                    FirebaseFirestore.instance.collection('movies');
                try {
                  await users
                      .doc(movie['id'])
                      .delete()
                      .then(
                        (value) => {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Movie deleted successfully'),
                              duration: Duration(milliseconds: 1500),
                            ),
                          ),
                          Navigator.pushReplacementNamed(
                              context, "feed_screen"),
                        },
                      )
                      .catchError(
                          (error) => print("Failed to delete user: $error"));
                } catch (e) {
                  print(e);
                }
              },
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
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: AppButtons.appElevatedButtonIcon(
                      icon: const Icon(Icons.edit),
                      name: "Edit Movie",
                      onPressed: () async {
                        CollectionReference movies =
                            FirebaseFirestore.instance.collection('movies');
                        print(movie["id"]);
                        print(_imdbRatingController.text);
                        await movies
                            .doc(movie["id"])
                            .update({
                              'name': _movieNameController.text,
                              'year': int.parse(_releaseYearController.text),
                              'rating': int.parse(_imdbRatingController.text),
                              'runtime': int.parse(_runtimeController.text),
                              'categories': _categoriesController.text
                                  .split(",")
                                  .map((e) => e.trim())
                                  .toList(),
                              'description': _descriptionController.text,
                              'image': _imageController.text
                            })
                            .then(
                              (value) => {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Movie edited successfully'),
                                    duration: Duration(milliseconds: 1500),
                                  ),
                                ),
                                Navigator.pushReplacementNamed(
                                    context, "feed_screen"),
                              },
                            )
                            .catchError((error) =>
                                print("Failed to update user: $error"));
                        Navigator.pushNamed(context, "feed_screen");
                      },
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

  /*@override
  void dispose() {
    _movieNameController.dispose();
    _releaseYearController.dispose();
    _imdbRatingController.dispose();
    _categoriesController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
    super.dispose();
  }*/

}

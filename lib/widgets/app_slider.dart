import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'app_buttons.dart';
import 'app_cards.dart';

final Query _moviesStream = FirebaseFirestore.instance.collection('movies');

class AppSlider {
  static Widget movieSlider({
    required BuildContext context,
    required String title,
    required bool isOrderByRating,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 20)),
            AppButtons.appTextButton(
              name: "see more",
              onPressed: () {
                Navigator.pushNamed(context, 'see_more_screen', arguments: {
                  'title': title,
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 5),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: StreamBuilder(
            stream: title == "Recently Added"
                ? _moviesStream
                    .orderBy('created', descending: true)
                    .limit(15)
                    .snapshots()
                : _moviesStream
                    .where(
                      'categories',
                      arrayContains: title == "Popular" ? null : title,
                    )
                    .where(
                      'rating',
                      isGreaterThan: title == "Popular" ? 80 : 60,
                    )
                    .orderBy('rating', descending: true)
                    .limit(15)
                    .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  child: const Center(child: CircularProgressIndicator()),
                );
              } else {
                return Row(
                  children: snapshot.data!.docs.map((e) {
                    Map<String, dynamic> movie =
                        e.data()! as Map<String, dynamic>;
                    Map<String, dynamic> _movie = {"id": e.id, ...movie};
                    return AppCards.movieCard(
                      movie: _movie,
                      context: context,
                    );
                  }).toList(),
                );
              }
            },
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}

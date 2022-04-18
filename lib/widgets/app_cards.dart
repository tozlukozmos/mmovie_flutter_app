import 'package:flutter/material.dart';

class AppCards {
  static Widget movieCard({
    required Map movie,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () => {
        Navigator.pushNamed(context, 'movie_detail_screen', arguments: {
          'movie': movie
        }),
      },
      child: Card(
        margin: const EdgeInsets.only(right: 15),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.network(
            movie['image'],
            width: 200,
            height: 300,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  static Widget movieCardMini({
    required Map movie,
    required BuildContext context,
  }) {
    return ListTile(
      leading: Image.network(movie['image']),
      title: Text(movie['name']),
      subtitle: Text(movie['year'].toString()),
      onTap: () => {
        Navigator.pushNamed(context, 'movie_detail_screen', arguments: {
          'movie': movie,
        }),
      },
    );
  }
}

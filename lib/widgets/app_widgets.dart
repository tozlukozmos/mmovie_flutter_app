import 'package:flutter/material.dart';

class AppWidgets {
  static Widget movieCard(Map movie, context) {
    return GestureDetector(
      onTap: () => {
        Navigator.pushNamed(context, 'movie_detail_screen', arguments: {
          'movie': movie,
        }),
      },
      child: Card(
        margin: const EdgeInsets.only(right: 20),
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

  static Widget movieCardMini(movie, context, id) {
    return ListTile(
      leading: Image.network(movie['image']),
      title: Text(movie['name']),
      subtitle: Text(movie['year'].toString()),
      onTap: () => {
        Navigator.pushNamed(context, 'movie_detail_screen',
            arguments: {'movie': movie, 'id': id}),
      },
    );
  }
}

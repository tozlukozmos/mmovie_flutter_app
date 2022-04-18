import 'package:flutter/material.dart';

class AppCards {
  static Widget movieCard({
    required Map movie,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () => {
        Navigator.pushNamed(context, 'movie_detail_screen',
            arguments: {'movie': movie}),
      },
      child: Card(
          margin: const EdgeInsets.only(right: 15),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  movie['image'],
                  width: 200,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Align(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [ThemeData.dark().primaryColor, Colors.black12],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                right: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: ThemeData.dark().primaryColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_month_rounded),
                          const SizedBox(width: 5),
                          Text(movie["year"].toString()),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: ThemeData.dark().primaryColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star_rate_rounded),
                          const SizedBox(width: 5),
                          Text((movie["rating"] / 10).toString()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 10,
                bottom: 10,
                width: 185,
                child: Text(
                  movie["name"],
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ],
          )),
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

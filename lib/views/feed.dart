import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';
import '../widgets/app_slider.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Feed();
}

class _Feed extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Feed")),
        drawer: AppDrawer(),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            AppSlider.movieSlider(
              context: context,
              title: "Popular",
              isOrderByRating: true,
            ),
            AppSlider.movieSlider(
              context: context,
              title: "Animation",
              isOrderByRating: true,
            ),
            AppSlider.movieSlider(
              context: context,
              title: "Drama",
              isOrderByRating: true,
            ),
            AppSlider.movieSlider(
              context: context,
              title: "Comedy",
              isOrderByRating: true,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, "add_movie_screen");
          },
        ),
      ),
    );
  }
}

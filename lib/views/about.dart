import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Search")),
        body: const Text(
            "I have been living some difficulties when my cousins, friends, and siblings suggesting a movie to me, such as forgetting and missing messages. Thanks to the application we may have a digital movie archive, and we can share movies in easier way, we can create wish list and favourites list. I hope it would work as expected."),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);
  final String about = "I have been experiencing some difficulties when my cousins," +
      " friends, and siblings suggesting a movie to me, such as forgetting and" +
      " missing messages. Thanks to the application we may have a digital movie" +
      " archive, and we can share movies in easier way, we can create wish list" +
      " and favourites list. I hope it would work as expected.";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("About")),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(about, style: const TextStyle(height: 1.5)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("MMovie ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Icon(Icons.copyright_rounded),
                  Text(" 2022", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

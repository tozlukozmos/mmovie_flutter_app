import 'package:flutter/material.dart';

class MovieDetail extends StatefulWidget {
  const MovieDetail({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MovieDetail();
}

class _MovieDetail extends State<MovieDetail> {
  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    final _movie = arg['movie'];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Details")),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: Text(_movie['name'], style: const TextStyle(fontSize: 20)),
            ),
            const SizedBox(height: 30),
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(_movie['image'], width: 200, height: 300),
                  ),
                  Positioned(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Text(_movie['year'].toString()),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(5)),
                      ),
                    ),
                  ),
                  Positioned(
                    right: -18,
                    bottom: -18,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Theme.of(context).colorScheme.background,
                      ),
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          CircularProgressIndicator(
                            color: getRatingColor(_movie['rating'] / 100),
                            value: _movie['rating'] / 100,
                          ),
                          Positioned.fill(
                            child: Align(child: Text(_movie['rating'].toString())),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Center(child: Text(getCategories(_movie['categories']))),
            const SizedBox(height: 30),
            const Text("Description", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            Text(_movie['description']),
          ],
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

  Color getRatingColor(number) {
    if (number >= 0.8) {
      return Colors.green;
    } else if (number >= 0.5) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }
}

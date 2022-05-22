import 'package:flutter/material.dart';

import '../views/about.dart';
import '../views/search.dart';
import '../views/add_movie.dart';
import '../views/favorites.dart';
import '../views/feed.dart';
import '../views/login.dart';
import '../views/movie_detail.dart';
import '../views/see_more.dart';
import '../views/signup.dart';
import '../views/welcome.dart';
import '../views/wishlist.dart';

Map<String, Widget Function(BuildContext)> routes = {
  'welcome_screen': (context) => const Welcome(),
  'login_screen': (context) => const Login(),
  'signup_screen': (context) => const Signup(),
  'feed_screen': (context) => const Feed(),
  'movie_detail_screen': (context) => const MovieDetail(),
  'see_more_screen': (context) => const SeeMore(),
  'add_movie_screen': (context) => const AddMovie(),
  'favorites_screen': (context) => const Favorites(),
  'wishlist_screen': (context) => const Wishlist(),
  'search_screen': (context) => const Search(),
  'about_screen': (context) => const About(),
};

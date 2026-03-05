import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie/src/presentation/pages/home_movie_page.dart';
import 'package:movie/src/presentation/pages/movie_detail_page.dart';
import 'package:movie/src/presentation/pages/popular_movies_page.dart';
import 'package:movie/src/presentation/pages/search_page.dart';
import 'package:movie/src/presentation/pages/top_rated_movies_page.dart';
import 'package:movie/src/presentation/pages/watchlist_movies_page.dart';

class MovieRoutes {
  static const home = '/home';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeMoviePage());
      case PopularMoviesPage.routeName:
        return CupertinoPageRoute(builder: (_) => const PopularMoviesPage());
      case TopRatedMoviesPage.routeName:
        return CupertinoPageRoute(builder: (_) => const TopRatedMoviesPage());
      case MovieDetailPage.routeName:
        final id = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => MovieDetailPage(id: id),
          settings: settings,
        );
      case SearchPage.routeName:
        return CupertinoPageRoute(builder: (_) => const SearchPage());
      case WatchlistMoviesPage.routeName:
        return MaterialPageRoute(builder: (_) => const WatchlistMoviesPage());
      default:
        return null;
    }
  }
}

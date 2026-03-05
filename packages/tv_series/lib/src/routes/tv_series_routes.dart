import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tv_series/src/presentation/pages/home_tv_series_page.dart';
import 'package:tv_series/src/presentation/pages/on_the_air_tv_series_page.dart';
import 'package:tv_series/src/presentation/pages/popular_tv_series_page.dart';
import 'package:tv_series/src/presentation/pages/search_tv_series_page.dart';
import 'package:tv_series/src/presentation/pages/top_rated_tv_series_page.dart';
import 'package:tv_series/src/presentation/pages/tv_series_detail_page.dart';
import 'package:tv_series/src/presentation/pages/watchlist_tv_series_page.dart';

class TvSeriesRoutes {
  static const home = '/home-tv';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeTvSeriesPage());
      case OnTheAirTvSeriesPage.routeName:
        return CupertinoPageRoute(builder: (_) => const OnTheAirTvSeriesPage());
      case PopularTvSeriesPage.routeName:
        return CupertinoPageRoute(builder: (_) => const PopularTvSeriesPage());
      case TopRatedTvSeriesPage.routeName:
        return CupertinoPageRoute(builder: (_) => const TopRatedTvSeriesPage());
      case TvSeriesDetailPage.routeName:
        final id = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => TvSeriesDetailPage(id: id),
          settings: settings,
        );
      case SearchTvSeriesPage.routeName:
        return CupertinoPageRoute(builder: (_) => const SearchTvSeriesPage());
      case WatchlistTvSeriesPage.routeName:
        return MaterialPageRoute(builder: (_) => const WatchlistTvSeriesPage());
      default:
        return null;
    }
  }
}

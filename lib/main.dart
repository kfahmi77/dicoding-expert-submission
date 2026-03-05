import 'dart:async';

import 'package:core/core.dart';
import 'package:ditonton/common/firebase_monitoring.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/movie.dart';
import 'package:tv_series/tv_series.dart';

Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await FirebaseMonitoring.initialize();
      di.init();
      runApp(const MyApp());
    },
    (error, stackTrace) {
      FirebaseMonitoring.recordError(error, stackTrace, fatal: true);
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final analyticsObserver = FirebaseMonitoring.analyticsObserver;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.locator<MovieListCubit>()),
        BlocProvider(create: (_) => di.locator<MovieDetailCubit>()),
        BlocProvider(create: (_) => di.locator<MovieSearchCubit>()),
        BlocProvider(create: (_) => di.locator<WatchlistMovieCubit>()),
        BlocProvider(create: (_) => di.locator<TvSeriesListCubit>()),
        BlocProvider(create: (_) => di.locator<TvSeriesDetailCubit>()),
        BlocProvider(create: (_) => di.locator<TvSeriesSearchCubit>()),
        BlocProvider(create: (_) => di.locator<WatchlistTvSeriesCubit>()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
          drawerTheme: kDrawerTheme,
        ),
        home: const HomeMoviePage(),
        navigatorObservers: [
          routeObserver,
          ...[analyticsObserver].whereType<NavigatorObserver>(),
        ],
        onGenerateRoute: (settings) {
          final movieRoute = MovieRoutes.onGenerateRoute(settings);
          if (movieRoute != null) {
            return movieRoute;
          }

          final tvSeriesRoute = TvSeriesRoutes.onGenerateRoute(settings);
          if (tvSeriesRoute != null) {
            return tvSeriesRoute;
          }

          switch (settings.name) {
            case AboutPage.routeName:
              return MaterialPageRoute(builder: (_) => const AboutPage());
            default:
              return MaterialPageRoute(
                builder: (_) => const Scaffold(
                  body: Center(child: Text('Page not found :(')),
                ),
              );
          }
        },
      ),
    );
  }
}

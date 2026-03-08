import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:movie/movie.dart';
import 'package:tv_series/tv_series.dart';

final locator = GetIt.instance;

Future<void> init() async {
  registerCoreModule(locator);
  registerMovieModule(locator);
  registerTvSeriesModule(locator);
  await locator.allReady();
}

import 'package:core/data/datasources/db/database_helper.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:movie/src/data/datasources/movie_local_data_source.dart';
import 'package:movie/src/data/datasources/movie_remote_data_source.dart';
import 'package:movie/src/data/repositories/movie_repository_impl.dart';
import 'package:movie/src/domain/repositories/movie_repository.dart';
import 'package:movie/src/domain/usecases/get_movie_detail.dart';
import 'package:movie/src/domain/usecases/get_movie_recommendations.dart';
import 'package:movie/src/domain/usecases/get_now_playing_movies.dart';
import 'package:movie/src/domain/usecases/get_popular_movies.dart';
import 'package:movie/src/domain/usecases/get_top_rated_movies.dart';
import 'package:movie/src/domain/usecases/get_watchlist_movies.dart';
import 'package:movie/src/domain/usecases/get_watchlist_status.dart';
import 'package:movie/src/domain/usecases/remove_watchlist.dart';
import 'package:movie/src/domain/usecases/save_watchlist.dart';
import 'package:movie/src/domain/usecases/search_movies.dart';
import 'package:movie/src/presentation/bloc/movie_detail/movie_detail_cubit.dart';
import 'package:movie/src/presentation/bloc/movie_list/movie_list_cubit.dart';
import 'package:movie/src/presentation/bloc/movie_search/movie_search_cubit.dart';
import 'package:movie/src/presentation/bloc/watchlist_movie/watchlist_movie_cubit.dart';
import 'package:movie/src/presentation/provider/movie_detail_notifier.dart';
import 'package:movie/src/presentation/provider/movie_list_notifier.dart';
import 'package:movie/src/presentation/provider/movie_search_notifier.dart';
import 'package:movie/src/presentation/provider/popular_movies_notifier.dart';
import 'package:movie/src/presentation/provider/top_rated_movies_notifier.dart';
import 'package:movie/src/presentation/provider/watchlist_movie_notifier.dart';

void registerMovieModule(GetIt locator) {
  if (!locator.isRegistered<MovieListCubit>()) {
    locator.registerFactory(
      () => MovieListCubit(
        getNowPlayingMovies: locator(),
        getPopularMovies: locator(),
        getTopRatedMovies: locator(),
      ),
    );
  }
  if (!locator.isRegistered<MovieDetailCubit>()) {
    locator.registerFactory(
      () => MovieDetailCubit(
        getMovieDetail: locator(),
        getMovieRecommendations: locator(),
        getWatchListStatus: locator(),
        saveWatchlist: locator(),
        removeWatchlist: locator(),
      ),
    );
  }
  if (!locator.isRegistered<MovieSearchCubit>()) {
    locator.registerFactory(() => MovieSearchCubit(searchMovies: locator()));
  }
  if (!locator.isRegistered<WatchlistMovieCubit>()) {
    locator.registerFactory(
      () => WatchlistMovieCubit(getWatchlistMovies: locator()),
    );
  }

  if (!locator.isRegistered<MovieListNotifier>()) {
    locator.registerFactory(
      () => MovieListNotifier(
        getNowPlayingMovies: locator(),
        getPopularMovies: locator(),
        getTopRatedMovies: locator(),
      ),
    );
  }
  if (!locator.isRegistered<MovieDetailNotifier>()) {
    locator.registerFactory(
      () => MovieDetailNotifier(
        getMovieDetail: locator(),
        getMovieRecommendations: locator(),
        getWatchListStatus: locator(),
        saveWatchlist: locator(),
        removeWatchlist: locator(),
      ),
    );
  }
  if (!locator.isRegistered<MovieSearchNotifier>()) {
    locator.registerFactory(() => MovieSearchNotifier(searchMovies: locator()));
  }
  if (!locator.isRegistered<PopularMoviesNotifier>()) {
    locator.registerFactory(() => PopularMoviesNotifier(locator()));
  }
  if (!locator.isRegistered<TopRatedMoviesNotifier>()) {
    locator.registerFactory(
      () => TopRatedMoviesNotifier(getTopRatedMovies: locator()),
    );
  }
  if (!locator.isRegistered<WatchlistMovieNotifier>()) {
    locator.registerFactory(
      () => WatchlistMovieNotifier(getWatchlistMovies: locator()),
    );
  }

  if (!locator.isRegistered<GetNowPlayingMovies>()) {
    locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  }
  if (!locator.isRegistered<GetPopularMovies>()) {
    locator.registerLazySingleton(() => GetPopularMovies(locator()));
  }
  if (!locator.isRegistered<GetTopRatedMovies>()) {
    locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  }
  if (!locator.isRegistered<GetMovieDetail>()) {
    locator.registerLazySingleton(() => GetMovieDetail(locator()));
  }
  if (!locator.isRegistered<GetMovieRecommendations>()) {
    locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  }
  if (!locator.isRegistered<SearchMovies>()) {
    locator.registerLazySingleton(() => SearchMovies(locator()));
  }
  if (!locator.isRegistered<GetWatchListStatus>()) {
    locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  }
  if (!locator.isRegistered<SaveWatchlist>()) {
    locator.registerLazySingleton(() => SaveWatchlist(locator()));
  }
  if (!locator.isRegistered<RemoveWatchlist>()) {
    locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  }
  if (!locator.isRegistered<GetWatchlistMovies>()) {
    locator.registerLazySingleton(() => GetWatchlistMovies(locator()));
  }

  if (!locator.isRegistered<MovieRepository>()) {
    locator.registerLazySingleton<MovieRepository>(
      () => MovieRepositoryImpl(
        remoteDataSource: locator(),
        localDataSource: locator(),
      ),
    );
  }

  if (!locator.isRegistered<MovieRemoteDataSource>()) {
    locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator<http.Client>()),
    );
  }
  if (!locator.isRegistered<MovieLocalDataSource>()) {
    locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator<DatabaseHelper>()),
    );
  }
}

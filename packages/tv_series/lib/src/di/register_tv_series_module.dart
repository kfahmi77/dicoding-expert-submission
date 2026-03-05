import 'package:core/data/datasources/db/database_helper.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:tv_series/src/data/datasources/tv_series_local_data_source.dart';
import 'package:tv_series/src/data/datasources/tv_series_remote_data_source.dart';
import 'package:tv_series/src/data/repositories/tv_series_repository_impl.dart';
import 'package:tv_series/src/domain/repositories/tv_series_repository.dart';
import 'package:tv_series/src/domain/usecases/get_on_the_air_tv_series.dart';
import 'package:tv_series/src/domain/usecases/get_popular_tv_series.dart';
import 'package:tv_series/src/domain/usecases/get_top_rated_tv_series.dart';
import 'package:tv_series/src/domain/usecases/get_tv_series_detail.dart';
import 'package:tv_series/src/domain/usecases/get_tv_series_recommendations.dart';
import 'package:tv_series/src/domain/usecases/get_watchlist_status_tv_series.dart';
import 'package:tv_series/src/domain/usecases/get_watchlist_tv_series.dart';
import 'package:tv_series/src/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:tv_series/src/domain/usecases/save_watchlist_tv_series.dart';
import 'package:tv_series/src/domain/usecases/search_tv_series.dart';
import 'package:tv_series/src/presentation/bloc/tv_series_detail/tv_series_detail_cubit.dart';
import 'package:tv_series/src/presentation/bloc/tv_series_list/tv_series_list_cubit.dart';
import 'package:tv_series/src/presentation/bloc/tv_series_search/tv_series_search_cubit.dart';
import 'package:tv_series/src/presentation/bloc/watchlist_tv_series/watchlist_tv_series_cubit.dart';
import 'package:tv_series/src/presentation/provider/on_the_air_tv_series_notifier.dart';
import 'package:tv_series/src/presentation/provider/popular_tv_series_notifier.dart';
import 'package:tv_series/src/presentation/provider/top_rated_tv_series_notifier.dart';
import 'package:tv_series/src/presentation/provider/tv_series_detail_notifier.dart';
import 'package:tv_series/src/presentation/provider/tv_series_list_notifier.dart';
import 'package:tv_series/src/presentation/provider/tv_series_search_notifier.dart';
import 'package:tv_series/src/presentation/provider/watchlist_tv_series_notifier.dart';

void registerTvSeriesModule(GetIt locator) {
  if (!locator.isRegistered<TvSeriesListCubit>()) {
    locator.registerFactory(
      () => TvSeriesListCubit(
        getOnTheAirTvSeries: locator(),
        getPopularTvSeries: locator(),
        getTopRatedTvSeries: locator(),
      ),
    );
  }
  if (!locator.isRegistered<TvSeriesDetailCubit>()) {
    locator.registerFactory(
      () => TvSeriesDetailCubit(
        getTvSeriesDetail: locator(),
        getTvSeriesRecommendations: locator(),
        getWatchlistStatusTvSeries: locator(),
        saveWatchlistTvSeries: locator(),
        removeWatchlistTvSeries: locator(),
      ),
    );
  }
  if (!locator.isRegistered<TvSeriesSearchCubit>()) {
    locator.registerFactory(
      () => TvSeriesSearchCubit(searchTvSeries: locator()),
    );
  }
  if (!locator.isRegistered<WatchlistTvSeriesCubit>()) {
    locator.registerFactory(
      () => WatchlistTvSeriesCubit(getWatchlistTvSeries: locator()),
    );
  }

  if (!locator.isRegistered<TvSeriesListNotifier>()) {
    locator.registerFactory(
      () => TvSeriesListNotifier(
        getOnTheAirTvSeries: locator(),
        getPopularTvSeries: locator(),
        getTopRatedTvSeries: locator(),
      ),
    );
  }
  if (!locator.isRegistered<OnTheAirTvSeriesNotifier>()) {
    locator.registerFactory(() => OnTheAirTvSeriesNotifier(locator()));
  }
  if (!locator.isRegistered<PopularTvSeriesNotifier>()) {
    locator.registerFactory(() => PopularTvSeriesNotifier(locator()));
  }
  if (!locator.isRegistered<TopRatedTvSeriesNotifier>()) {
    locator.registerFactory(() => TopRatedTvSeriesNotifier(locator()));
  }
  if (!locator.isRegistered<TvSeriesDetailNotifier>()) {
    locator.registerFactory(
      () => TvSeriesDetailNotifier(
        getTvSeriesDetail: locator(),
        getTvSeriesRecommendations: locator(),
        getWatchlistStatusTvSeries: locator(),
        saveWatchlistTvSeries: locator(),
        removeWatchlistTvSeries: locator(),
      ),
    );
  }
  if (!locator.isRegistered<TvSeriesSearchNotifier>()) {
    locator.registerFactory(
      () => TvSeriesSearchNotifier(searchTvSeries: locator()),
    );
  }
  if (!locator.isRegistered<WatchlistTvSeriesNotifier>()) {
    locator.registerFactory(
      () => WatchlistTvSeriesNotifier(getWatchlistTvSeries: locator()),
    );
  }

  if (!locator.isRegistered<GetOnTheAirTvSeries>()) {
    locator.registerLazySingleton(() => GetOnTheAirTvSeries(locator()));
  }
  if (!locator.isRegistered<GetPopularTvSeries>()) {
    locator.registerLazySingleton(() => GetPopularTvSeries(locator()));
  }
  if (!locator.isRegistered<GetTopRatedTvSeries>()) {
    locator.registerLazySingleton(() => GetTopRatedTvSeries(locator()));
  }
  if (!locator.isRegistered<GetTvSeriesDetail>()) {
    locator.registerLazySingleton(() => GetTvSeriesDetail(locator()));
  }
  if (!locator.isRegistered<GetTvSeriesRecommendations>()) {
    locator.registerLazySingleton(() => GetTvSeriesRecommendations(locator()));
  }
  if (!locator.isRegistered<SearchTvSeries>()) {
    locator.registerLazySingleton(() => SearchTvSeries(locator()));
  }
  if (!locator.isRegistered<GetWatchlistStatusTvSeries>()) {
    locator.registerLazySingleton(() => GetWatchlistStatusTvSeries(locator()));
  }
  if (!locator.isRegistered<SaveWatchlistTvSeries>()) {
    locator.registerLazySingleton(() => SaveWatchlistTvSeries(locator()));
  }
  if (!locator.isRegistered<RemoveWatchlistTvSeries>()) {
    locator.registerLazySingleton(() => RemoveWatchlistTvSeries(locator()));
  }
  if (!locator.isRegistered<GetWatchlistTvSeries>()) {
    locator.registerLazySingleton(() => GetWatchlistTvSeries(locator()));
  }

  if (!locator.isRegistered<TvSeriesRepository>()) {
    locator.registerLazySingleton<TvSeriesRepository>(
      () => TvSeriesRepositoryImpl(
        remoteDataSource: locator(),
        localDataSource: locator(),
      ),
    );
  }

  if (!locator.isRegistered<TvSeriesRemoteDataSource>()) {
    locator.registerLazySingleton<TvSeriesRemoteDataSource>(
      () => TvSeriesRemoteDataSourceImpl(client: locator<http.Client>()),
    );
  }
  if (!locator.isRegistered<TvSeriesLocalDataSource>()) {
    locator.registerLazySingleton<TvSeriesLocalDataSource>(
      () => TvSeriesLocalDataSourceImpl(
        databaseHelper: locator<DatabaseHelper>(),
      ),
    );
  }
}

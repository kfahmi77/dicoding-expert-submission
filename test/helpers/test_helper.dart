import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/data/datasources/tv_series_local_data_source.dart';
import 'package:ditonton/data/datasources/tv_series_remote_data_source.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tv_series.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_tv_series.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:ditonton/presentation/provider/on_the_air_tv_series_notifier.dart';
import 'package:ditonton/presentation/provider/popular_tv_series_notifier.dart';
import 'package:ditonton/presentation/provider/top_rated_tv_series_notifier.dart';
import 'package:ditonton/presentation/provider/tv_series_detail_notifier.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';

@GenerateMocks(
  [
    MovieRepository,
    MovieRemoteDataSource,
    MovieLocalDataSource,
    TvSeriesRepository,
    TvSeriesRemoteDataSource,
    TvSeriesLocalDataSource,
    GetOnTheAirTvSeries,
    GetPopularTvSeries,
    GetTopRatedTvSeries,
    GetTvSeriesDetail,
    GetTvSeriesRecommendations,
    SearchTvSeries,
    GetWatchlistStatusTvSeries,
    SaveWatchlistTvSeries,
    RemoveWatchlistTvSeries,
    GetWatchlistTvSeries,
    OnTheAirTvSeriesNotifier,
    PopularTvSeriesNotifier,
    TopRatedTvSeriesNotifier,
    TvSeriesDetailNotifier,
    DatabaseHelper,
  ],
  customMocks: [MockSpec<http.Client>(as: #MockHttpClient)],
)
void main() {}

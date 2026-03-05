import 'package:core/common/state_enum.dart';
import 'package:tv_series/src/domain/entities/tv_series.dart';
import 'package:tv_series/src/domain/usecases/get_on_the_air_tv_series.dart';
import 'package:tv_series/src/domain/usecases/get_popular_tv_series.dart';
import 'package:tv_series/src/domain/usecases/get_top_rated_tv_series.dart';
import 'package:flutter/material.dart';

class TvSeriesListNotifier extends ChangeNotifier {
  TvSeriesListNotifier({
    required this.getOnTheAirTvSeries,
    required this.getPopularTvSeries,
    required this.getTopRatedTvSeries,
  });

  final GetOnTheAirTvSeries getOnTheAirTvSeries;
  final GetPopularTvSeries getPopularTvSeries;
  final GetTopRatedTvSeries getTopRatedTvSeries;

  var _onTheAirTvSeries = <TvSeries>[];
  List<TvSeries> get onTheAirTvSeries => _onTheAirTvSeries;

  RequestState _onTheAirState = RequestState.Empty;
  RequestState get onTheAirState => _onTheAirState;

  var _popularTvSeries = <TvSeries>[];
  List<TvSeries> get popularTvSeries => _popularTvSeries;

  RequestState _popularTvSeriesState = RequestState.Empty;
  RequestState get popularTvSeriesState => _popularTvSeriesState;

  var _topRatedTvSeries = <TvSeries>[];
  List<TvSeries> get topRatedTvSeries => _topRatedTvSeries;

  RequestState _topRatedTvSeriesState = RequestState.Empty;
  RequestState get topRatedTvSeriesState => _topRatedTvSeriesState;

  String _message = '';
  String get message => _message;

  Future<void> fetchOnTheAirTvSeries() async {
    _onTheAirState = RequestState.Loading;
    notifyListeners();

    final result = await getOnTheAirTvSeries.execute();
    result.fold(
      (failure) {
        _onTheAirState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (data) {
        _onTheAirState = RequestState.Loaded;
        _onTheAirTvSeries = data;
        notifyListeners();
      },
    );
  }

  Future<void> fetchPopularTvSeries() async {
    _popularTvSeriesState = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTvSeries.execute();
    result.fold(
      (failure) {
        _popularTvSeriesState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (data) {
        _popularTvSeriesState = RequestState.Loaded;
        _popularTvSeries = data;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopRatedTvSeries() async {
    _topRatedTvSeriesState = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTvSeries.execute();
    result.fold(
      (failure) {
        _topRatedTvSeriesState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (data) {
        _topRatedTvSeriesState = RequestState.Loaded;
        _topRatedTvSeries = data;
        notifyListeners();
      },
    );
  }
}

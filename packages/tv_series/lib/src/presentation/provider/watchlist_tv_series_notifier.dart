import 'package:core/common/state_enum.dart';
import 'package:tv_series/src/domain/entities/tv_series.dart';
import 'package:tv_series/src/domain/usecases/get_watchlist_tv_series.dart';
import 'package:flutter/foundation.dart';

class WatchlistTvSeriesNotifier extends ChangeNotifier {
  WatchlistTvSeriesNotifier({required this.getWatchlistTvSeries});

  final GetWatchlistTvSeries getWatchlistTvSeries;

  var _watchlistTvSeries = <TvSeries>[];
  List<TvSeries> get watchlistTvSeries => _watchlistTvSeries;

  var _watchlistState = RequestState.Empty;
  RequestState get watchlistState => _watchlistState;

  String _message = '';
  String get message => _message;

  Future<void> fetchWatchlistTvSeries() async {
    _watchlistState = RequestState.Loading;
    notifyListeners();

    final result = await getWatchlistTvSeries.execute();
    result.fold(
      (failure) {
        _watchlistState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (data) {
        _watchlistState = RequestState.Loaded;
        _watchlistTvSeries = data;
        notifyListeners();
      },
    );
  }
}

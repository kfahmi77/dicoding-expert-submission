import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_series.dart';
import 'package:equatable/equatable.dart';

class WatchlistTvSeriesState extends Equatable {
  const WatchlistTvSeriesState({
    this.watchlistTvSeries = const <TvSeries>[],
    this.watchlistState = RequestState.Empty,
    this.message = '',
  });

  final List<TvSeries> watchlistTvSeries;
  final RequestState watchlistState;
  final String message;

  WatchlistTvSeriesState copyWith({
    List<TvSeries>? watchlistTvSeries,
    RequestState? watchlistState,
    String? message,
  }) {
    return WatchlistTvSeriesState(
      watchlistTvSeries: watchlistTvSeries ?? this.watchlistTvSeries,
      watchlistState: watchlistState ?? this.watchlistState,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [watchlistTvSeries, watchlistState, message];
}

class WatchlistTvSeriesCubit extends Cubit<WatchlistTvSeriesState> {
  WatchlistTvSeriesCubit({required this.getWatchlistTvSeries})
    : super(const WatchlistTvSeriesState());

  final GetWatchlistTvSeries getWatchlistTvSeries;

  Future<void> fetchWatchlistTvSeries() async {
    emit(state.copyWith(watchlistState: RequestState.Loading, message: ''));

    final result = await getWatchlistTvSeries.execute();
    result.fold(
      (failure) => emit(
        state.copyWith(
          watchlistState: RequestState.Error,
          message: failure.message,
        ),
      ),
      (data) => emit(
        state.copyWith(
          watchlistState: RequestState.Loaded,
          watchlistTvSeries: data,
        ),
      ),
    );
  }
}

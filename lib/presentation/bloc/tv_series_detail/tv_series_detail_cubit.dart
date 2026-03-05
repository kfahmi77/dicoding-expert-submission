import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_tv_series.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_series.dart';
import 'package:equatable/equatable.dart';

class TvSeriesDetailState extends Equatable {
  const TvSeriesDetailState({
    this.tvSeries,
    this.tvSeriesState = RequestState.Empty,
    this.tvSeriesRecommendations = const <TvSeries>[],
    this.recommendationState = RequestState.Empty,
    this.message = '',
    this.watchlistMessage = '',
    this.isAddedToWatchlist = false,
  });

  final TvSeriesDetail? tvSeries;
  final RequestState tvSeriesState;
  final List<TvSeries> tvSeriesRecommendations;
  final RequestState recommendationState;
  final String message;
  final String watchlistMessage;
  final bool isAddedToWatchlist;

  TvSeriesDetailState copyWith({
    TvSeriesDetail? tvSeries,
    bool shouldClearTvSeries = false,
    RequestState? tvSeriesState,
    List<TvSeries>? tvSeriesRecommendations,
    RequestState? recommendationState,
    String? message,
    String? watchlistMessage,
    bool? isAddedToWatchlist,
  }) {
    return TvSeriesDetailState(
      tvSeries: shouldClearTvSeries ? null : (tvSeries ?? this.tvSeries),
      tvSeriesState: tvSeriesState ?? this.tvSeriesState,
      tvSeriesRecommendations:
          tvSeriesRecommendations ?? this.tvSeriesRecommendations,
      recommendationState: recommendationState ?? this.recommendationState,
      message: message ?? this.message,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
    );
  }

  @override
  List<Object?> get props => [
    tvSeries,
    tvSeriesState,
    tvSeriesRecommendations,
    recommendationState,
    message,
    watchlistMessage,
    isAddedToWatchlist,
  ];
}

class TvSeriesDetailCubit extends Cubit<TvSeriesDetailState> {
  TvSeriesDetailCubit({
    required this.getTvSeriesDetail,
    required this.getTvSeriesRecommendations,
    required this.getWatchlistStatusTvSeries,
    required this.saveWatchlistTvSeries,
    required this.removeWatchlistTvSeries,
  }) : super(const TvSeriesDetailState());

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvSeriesDetail getTvSeriesDetail;
  final GetTvSeriesRecommendations getTvSeriesRecommendations;
  final GetWatchlistStatusTvSeries getWatchlistStatusTvSeries;
  final SaveWatchlistTvSeries saveWatchlistTvSeries;
  final RemoveWatchlistTvSeries removeWatchlistTvSeries;

  Future<void> fetchTvSeriesDetail(int id) async {
    emit(
      state.copyWith(
        tvSeriesState: RequestState.Loading,
        recommendationState: RequestState.Empty,
        message: '',
      ),
    );

    final detailResult = await getTvSeriesDetail.execute(id);
    final recommendationResult = await getTvSeriesRecommendations.execute(id);

    await detailResult.fold(
      (failure) async {
        emit(
          state.copyWith(
            tvSeriesState: RequestState.Error,
            message: failure.message,
            shouldClearTvSeries: true,
            tvSeriesRecommendations: const <TvSeries>[],
          ),
        );
      },
      (data) async {
        emit(
          state.copyWith(
            tvSeries: data,
            recommendationState: RequestState.Loading,
            message: '',
          ),
        );

        recommendationResult.fold(
          (failure) {
            emit(
              state.copyWith(
                tvSeriesState: RequestState.Loaded,
                recommendationState: RequestState.Error,
                message: failure.message,
                tvSeriesRecommendations: const <TvSeries>[],
              ),
            );
          },
          (recommendations) {
            emit(
              state.copyWith(
                tvSeriesState: RequestState.Loaded,
                recommendationState: RequestState.Loaded,
                tvSeriesRecommendations: recommendations,
                message: '',
              ),
            );
          },
        );
      },
    );
  }

  Future<void> addWatchlist(TvSeriesDetail tvSeries) async {
    final result = await saveWatchlistTvSeries.execute(tvSeries);
    final message = result.fold(
      (failure) => failure.message,
      (success) => success,
    );

    emit(state.copyWith(watchlistMessage: message));
    await loadWatchlistStatus(tvSeries.id);
  }

  Future<void> removeFromWatchlist(TvSeriesDetail tvSeries) async {
    final result = await removeWatchlistTvSeries.execute(tvSeries);
    final message = result.fold(
      (failure) => failure.message,
      (success) => success,
    );

    emit(state.copyWith(watchlistMessage: message));
    await loadWatchlistStatus(tvSeries.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchlistStatusTvSeries.execute(id);
    emit(state.copyWith(isAddedToWatchlist: result));
  }
}

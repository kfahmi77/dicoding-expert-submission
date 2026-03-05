import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/common/state_enum.dart';
import 'package:movie/src/domain/entities/movie.dart';
import 'package:movie/src/domain/entities/movie_detail.dart';
import 'package:movie/src/domain/usecases/get_movie_detail.dart';
import 'package:movie/src/domain/usecases/get_movie_recommendations.dart';
import 'package:movie/src/domain/usecases/get_watchlist_status.dart';
import 'package:movie/src/domain/usecases/remove_watchlist.dart';
import 'package:movie/src/domain/usecases/save_watchlist.dart';
import 'package:equatable/equatable.dart';

class MovieDetailState extends Equatable {
  const MovieDetailState({
    this.movie,
    this.movieState = RequestState.Empty,
    this.movieRecommendations = const <Movie>[],
    this.recommendationState = RequestState.Empty,
    this.message = '',
    this.watchlistMessage = '',
    this.isAddedToWatchlist = false,
  });

  final MovieDetail? movie;
  final RequestState movieState;
  final List<Movie> movieRecommendations;
  final RequestState recommendationState;
  final String message;
  final String watchlistMessage;
  final bool isAddedToWatchlist;

  MovieDetailState copyWith({
    MovieDetail? movie,
    bool shouldClearMovie = false,
    RequestState? movieState,
    List<Movie>? movieRecommendations,
    RequestState? recommendationState,
    String? message,
    String? watchlistMessage,
    bool? isAddedToWatchlist,
  }) {
    return MovieDetailState(
      movie: shouldClearMovie ? null : (movie ?? this.movie),
      movieState: movieState ?? this.movieState,
      movieRecommendations: movieRecommendations ?? this.movieRecommendations,
      recommendationState: recommendationState ?? this.recommendationState,
      message: message ?? this.message,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
    );
  }

  @override
  List<Object?> get props => [
    movie,
    movieState,
    movieRecommendations,
    recommendationState,
    message,
    watchlistMessage,
    isAddedToWatchlist,
  ];
}

class MovieDetailCubit extends Cubit<MovieDetailState> {
  MovieDetailCubit({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(const MovieDetailState());

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  Future<void> fetchMovieDetail(int id) async {
    emit(
      state.copyWith(
        movieState: RequestState.Loading,
        recommendationState: RequestState.Empty,
        message: '',
      ),
    );

    final detailResult = await getMovieDetail.execute(id);
    final recommendationResult = await getMovieRecommendations.execute(id);

    await detailResult.fold(
      (failure) async {
        emit(
          state.copyWith(
            movieState: RequestState.Error,
            message: failure.message,
            shouldClearMovie: true,
            movieRecommendations: const <Movie>[],
          ),
        );
      },
      (movie) async {
        emit(
          state.copyWith(
            movie: movie,
            recommendationState: RequestState.Loading,
            message: '',
          ),
        );

        recommendationResult.fold(
          (failure) {
            emit(
              state.copyWith(
                movieState: RequestState.Loaded,
                recommendationState: RequestState.Error,
                message: failure.message,
                movieRecommendations: const <Movie>[],
              ),
            );
          },
          (movies) {
            emit(
              state.copyWith(
                movieState: RequestState.Loaded,
                recommendationState: RequestState.Loaded,
                movieRecommendations: movies,
                message: '',
              ),
            );
          },
        );
      },
    );
  }

  Future<void> addWatchlist(MovieDetail movie) async {
    final result = await saveWatchlist.execute(movie);
    final message = result.fold(
      (failure) => failure.message,
      (success) => success,
    );

    emit(state.copyWith(watchlistMessage: message));
    await loadWatchlistStatus(movie.id);
  }

  Future<void> removeFromWatchlist(MovieDetail movie) async {
    final result = await removeWatchlist.execute(movie);
    final message = result.fold(
      (failure) => failure.message,
      (success) => success,
    );

    emit(state.copyWith(watchlistMessage: message));
    await loadWatchlistStatus(movie.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchListStatus.execute(id);
    emit(state.copyWith(isAddedToWatchlist: result));
  }
}

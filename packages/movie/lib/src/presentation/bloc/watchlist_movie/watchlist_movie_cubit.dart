import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/common/state_enum.dart';
import 'package:movie/src/domain/entities/movie.dart';
import 'package:movie/src/domain/usecases/get_watchlist_movies.dart';
import 'package:equatable/equatable.dart';

class WatchlistMovieState extends Equatable {
  const WatchlistMovieState({
    this.watchlistMovies = const <Movie>[],
    this.watchlistState = RequestState.Empty,
    this.message = '',
  });

  final List<Movie> watchlistMovies;
  final RequestState watchlistState;
  final String message;

  WatchlistMovieState copyWith({
    List<Movie>? watchlistMovies,
    RequestState? watchlistState,
    String? message,
  }) {
    return WatchlistMovieState(
      watchlistMovies: watchlistMovies ?? this.watchlistMovies,
      watchlistState: watchlistState ?? this.watchlistState,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [watchlistMovies, watchlistState, message];
}

class WatchlistMovieCubit extends Cubit<WatchlistMovieState> {
  WatchlistMovieCubit({required this.getWatchlistMovies})
    : super(const WatchlistMovieState());

  final GetWatchlistMovies getWatchlistMovies;

  Future<void> fetchWatchlistMovies() async {
    emit(state.copyWith(watchlistState: RequestState.Loading, message: ''));

    final result = await getWatchlistMovies.execute();
    result.fold(
      (failure) => emit(
        state.copyWith(
          watchlistState: RequestState.Error,
          message: failure.message,
        ),
      ),
      (moviesData) => emit(
        state.copyWith(
          watchlistState: RequestState.Loaded,
          watchlistMovies: moviesData,
        ),
      ),
    );
  }
}

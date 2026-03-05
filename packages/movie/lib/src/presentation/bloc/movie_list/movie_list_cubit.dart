import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/common/state_enum.dart';
import 'package:movie/src/domain/entities/movie.dart';
import 'package:movie/src/domain/usecases/get_now_playing_movies.dart';
import 'package:movie/src/domain/usecases/get_popular_movies.dart';
import 'package:movie/src/domain/usecases/get_top_rated_movies.dart';
import 'package:equatable/equatable.dart';

class MovieListState extends Equatable {
  const MovieListState({
    this.nowPlayingMovies = const <Movie>[],
    this.nowPlayingState = RequestState.Empty,
    this.popularMovies = const <Movie>[],
    this.popularMoviesState = RequestState.Empty,
    this.topRatedMovies = const <Movie>[],
    this.topRatedMoviesState = RequestState.Empty,
    this.message = '',
  });

  final List<Movie> nowPlayingMovies;
  final RequestState nowPlayingState;
  final List<Movie> popularMovies;
  final RequestState popularMoviesState;
  final List<Movie> topRatedMovies;
  final RequestState topRatedMoviesState;
  final String message;

  MovieListState copyWith({
    List<Movie>? nowPlayingMovies,
    RequestState? nowPlayingState,
    List<Movie>? popularMovies,
    RequestState? popularMoviesState,
    List<Movie>? topRatedMovies,
    RequestState? topRatedMoviesState,
    String? message,
  }) {
    return MovieListState(
      nowPlayingMovies: nowPlayingMovies ?? this.nowPlayingMovies,
      nowPlayingState: nowPlayingState ?? this.nowPlayingState,
      popularMovies: popularMovies ?? this.popularMovies,
      popularMoviesState: popularMoviesState ?? this.popularMoviesState,
      topRatedMovies: topRatedMovies ?? this.topRatedMovies,
      topRatedMoviesState: topRatedMoviesState ?? this.topRatedMoviesState,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [
    nowPlayingMovies,
    nowPlayingState,
    popularMovies,
    popularMoviesState,
    topRatedMovies,
    topRatedMoviesState,
    message,
  ];
}

class MovieListCubit extends Cubit<MovieListState> {
  MovieListCubit({
    required this.getNowPlayingMovies,
    required this.getPopularMovies,
    required this.getTopRatedMovies,
  }) : super(const MovieListState());

  final GetNowPlayingMovies getNowPlayingMovies;
  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;

  Future<void> fetchNowPlayingMovies() async {
    emit(state.copyWith(nowPlayingState: RequestState.Loading, message: ''));

    final result = await getNowPlayingMovies.execute();
    result.fold(
      (failure) => emit(
        state.copyWith(
          nowPlayingState: RequestState.Error,
          message: failure.message,
        ),
      ),
      (moviesData) => emit(
        state.copyWith(
          nowPlayingState: RequestState.Loaded,
          nowPlayingMovies: moviesData,
        ),
      ),
    );
  }

  Future<void> fetchPopularMovies() async {
    emit(state.copyWith(popularMoviesState: RequestState.Loading, message: ''));

    final result = await getPopularMovies.execute();
    result.fold(
      (failure) => emit(
        state.copyWith(
          popularMoviesState: RequestState.Error,
          message: failure.message,
        ),
      ),
      (moviesData) => emit(
        state.copyWith(
          popularMoviesState: RequestState.Loaded,
          popularMovies: moviesData,
        ),
      ),
    );
  }

  Future<void> fetchTopRatedMovies() async {
    emit(
      state.copyWith(topRatedMoviesState: RequestState.Loading, message: ''),
    );

    final result = await getTopRatedMovies.execute();
    result.fold(
      (failure) => emit(
        state.copyWith(
          topRatedMoviesState: RequestState.Error,
          message: failure.message,
        ),
      ),
      (moviesData) => emit(
        state.copyWith(
          topRatedMoviesState: RequestState.Loaded,
          topRatedMovies: moviesData,
        ),
      ),
    );
  }
}

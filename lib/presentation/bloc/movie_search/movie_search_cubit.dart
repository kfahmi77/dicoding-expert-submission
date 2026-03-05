import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:equatable/equatable.dart';

class MovieSearchState extends Equatable {
  const MovieSearchState({
    this.state = RequestState.Empty,
    this.searchResult = const <Movie>[],
    this.message = '',
  });

  final RequestState state;
  final List<Movie> searchResult;
  final String message;

  MovieSearchState copyWith({
    RequestState? state,
    List<Movie>? searchResult,
    String? message,
  }) {
    return MovieSearchState(
      state: state ?? this.state,
      searchResult: searchResult ?? this.searchResult,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [state, searchResult, message];
}

class MovieSearchCubit extends Cubit<MovieSearchState> {
  MovieSearchCubit({required this.searchMovies})
    : super(const MovieSearchState());

  final SearchMovies searchMovies;

  Future<void> fetchMovieSearch(String query) async {
    emit(state.copyWith(state: RequestState.Loading, message: ''));

    final result = await searchMovies.execute(query);
    result.fold(
      (failure) => emit(
        state.copyWith(state: RequestState.Error, message: failure.message),
      ),
      (data) =>
          emit(state.copyWith(state: RequestState.Loaded, searchResult: data)),
    );
  }
}

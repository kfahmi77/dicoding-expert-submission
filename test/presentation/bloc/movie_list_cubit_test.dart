import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/presentation/bloc/movie_list/movie_list_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockGetNowPlayingMovies extends Mock implements GetNowPlayingMovies {}

class MockGetPopularMovies extends Mock implements GetPopularMovies {}

class MockGetTopRatedMovies extends Mock implements GetTopRatedMovies {}

void main() {
  late MovieListCubit cubit;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    cubit = MovieListCubit(
      getNowPlayingMovies: mockGetNowPlayingMovies,
      getPopularMovies: mockGetPopularMovies,
      getTopRatedMovies: mockGetTopRatedMovies,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('fetchNowPlayingMovies', () {
    blocTest<MovieListCubit, MovieListState>(
      'should emit Loading then Loaded when success',
      build: () {
        when(
          () => mockGetNowPlayingMovies.execute(),
        ).thenAnswer((_) async => Right(testMovieList));
        return cubit;
      },
      act: (cubit) => cubit.fetchNowPlayingMovies(),
      expect: () => [
        const MovieListState(
          nowPlayingState: RequestState.Loading,
          message: '',
        ),
        MovieListState(
          nowPlayingState: RequestState.Loaded,
          nowPlayingMovies: testMovieList,
        ),
      ],
    );

    blocTest<MovieListCubit, MovieListState>(
      'should emit Loading then Error when fails',
      build: () {
        when(
          () => mockGetNowPlayingMovies.execute(),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return cubit;
      },
      act: (cubit) => cubit.fetchNowPlayingMovies(),
      expect: () => [
        const MovieListState(
          nowPlayingState: RequestState.Loading,
          message: '',
        ),
        const MovieListState(
          nowPlayingState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
    );
  });

  group('fetchPopularMovies', () {
    blocTest<MovieListCubit, MovieListState>(
      'should emit Loading then Loaded when success',
      build: () {
        when(
          () => mockGetPopularMovies.execute(),
        ).thenAnswer((_) async => Right(testMovieList));
        return cubit;
      },
      act: (cubit) => cubit.fetchPopularMovies(),
      expect: () => [
        const MovieListState(
          popularMoviesState: RequestState.Loading,
          message: '',
        ),
        MovieListState(
          popularMoviesState: RequestState.Loaded,
          popularMovies: testMovieList,
        ),
      ],
    );

    blocTest<MovieListCubit, MovieListState>(
      'should emit Loading then Error when fails',
      build: () {
        when(
          () => mockGetPopularMovies.execute(),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return cubit;
      },
      act: (cubit) => cubit.fetchPopularMovies(),
      expect: () => [
        const MovieListState(
          popularMoviesState: RequestState.Loading,
          message: '',
        ),
        const MovieListState(
          popularMoviesState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
    );
  });

  group('fetchTopRatedMovies', () {
    blocTest<MovieListCubit, MovieListState>(
      'should emit Loading then Loaded when success',
      build: () {
        when(
          () => mockGetTopRatedMovies.execute(),
        ).thenAnswer((_) async => Right(testMovieList));
        return cubit;
      },
      act: (cubit) => cubit.fetchTopRatedMovies(),
      expect: () => [
        const MovieListState(
          topRatedMoviesState: RequestState.Loading,
          message: '',
        ),
        MovieListState(
          topRatedMoviesState: RequestState.Loaded,
          topRatedMovies: testMovieList,
        ),
      ],
    );

    blocTest<MovieListCubit, MovieListState>(
      'should emit Loading then Error when fails',
      build: () {
        when(
          () => mockGetTopRatedMovies.execute(),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return cubit;
      },
      act: (cubit) => cubit.fetchTopRatedMovies(),
      expect: () => [
        const MovieListState(
          topRatedMoviesState: RequestState.Loading,
          message: '',
        ),
        const MovieListState(
          topRatedMoviesState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
    );
  });
}

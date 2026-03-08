import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/presentation/bloc/watchlist_movie/watchlist_movie_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockGetWatchlistMovies extends Mock implements GetWatchlistMovies {}

void main() {
  late WatchlistMovieCubit cubit;
  late MockGetWatchlistMovies mockGetWatchlistMovies;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    cubit = WatchlistMovieCubit(getWatchlistMovies: mockGetWatchlistMovies);
  });

  tearDown(() {
    cubit.close();
  });

  group('fetchWatchlistMovies', () {
    blocTest<WatchlistMovieCubit, WatchlistMovieState>(
      'should emit Loading then Loaded when success',
      build: () {
        when(
          () => mockGetWatchlistMovies.execute(),
        ).thenAnswer((_) async => Right(testMovieList));
        return cubit;
      },
      act: (cubit) => cubit.fetchWatchlistMovies(),
      expect: () => [
        const WatchlistMovieState(
          watchlistState: RequestState.Loading,
          message: '',
        ),
        WatchlistMovieState(
          watchlistState: RequestState.Loaded,
          watchlistMovies: testMovieList,
        ),
      ],
      verify: (_) {
        verify(() => mockGetWatchlistMovies.execute()).called(1);
      },
    );

    blocTest<WatchlistMovieCubit, WatchlistMovieState>(
      'should emit Loading then Error when fails',
      build: () {
        when(
          () => mockGetWatchlistMovies.execute(),
        ).thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
        return cubit;
      },
      act: (cubit) => cubit.fetchWatchlistMovies(),
      expect: () => [
        const WatchlistMovieState(
          watchlistState: RequestState.Loading,
          message: '',
        ),
        const WatchlistMovieState(
          watchlistState: RequestState.Error,
          message: 'Database Failure',
        ),
      ],
    );
  });
}

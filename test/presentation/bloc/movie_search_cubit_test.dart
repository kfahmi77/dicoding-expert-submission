import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/presentation/bloc/movie_search/movie_search_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockSearchMovies extends Mock implements SearchMovies {}

void main() {
  late MovieSearchCubit cubit;
  late MockSearchMovies mockSearchMovies;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    cubit = MovieSearchCubit(searchMovies: mockSearchMovies);
  });

  tearDown(() {
    cubit.close();
  });

  const tQuery = 'spiderman';

  group('fetchMovieSearch', () {
    blocTest<MovieSearchCubit, MovieSearchState>(
      'should emit Loading then Loaded when search succeeds',
      build: () {
        when(
          () => mockSearchMovies.execute(tQuery),
        ).thenAnswer((_) async => Right(testMovieList));
        return cubit;
      },
      act: (cubit) => cubit.fetchMovieSearch(tQuery),
      expect: () => [
        const MovieSearchState(state: RequestState.Loading, message: ''),
        MovieSearchState(
          state: RequestState.Loaded,
          searchResult: testMovieList,
        ),
      ],
      verify: (_) {
        verify(() => mockSearchMovies.execute(tQuery)).called(1);
      },
    );

    blocTest<MovieSearchCubit, MovieSearchState>(
      'should emit Loading then Error when search fails',
      build: () {
        when(
          () => mockSearchMovies.execute(tQuery),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return cubit;
      },
      act: (cubit) => cubit.fetchMovieSearch(tQuery),
      expect: () => [
        const MovieSearchState(state: RequestState.Loading, message: ''),
        const MovieSearchState(
          state: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
    );
  });
}

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series_search/tv_series_search_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockSearchTvSeries extends Mock implements SearchTvSeries {}

void main() {
  late TvSeriesSearchCubit cubit;
  late MockSearchTvSeries mockSearchTvSeries;

  setUp(() {
    mockSearchTvSeries = MockSearchTvSeries();
    cubit = TvSeriesSearchCubit(searchTvSeries: mockSearchTvSeries);
  });

  tearDown(() {
    cubit.close();
  });

  const tQuery = 'drama';

  group('fetchTvSeriesSearch', () {
    blocTest<TvSeriesSearchCubit, TvSeriesSearchState>(
      'should emit Loading then Loaded when search succeeds',
      build: () {
        when(
          () => mockSearchTvSeries.execute(tQuery),
        ).thenAnswer((_) async => Right(testTvSeriesList));
        return cubit;
      },
      act: (cubit) => cubit.fetchTvSeriesSearch(tQuery),
      expect: () => [
        const TvSeriesSearchState(state: RequestState.Loading, message: ''),
        TvSeriesSearchState(
          state: RequestState.Loaded,
          searchResult: testTvSeriesList,
        ),
      ],
      verify: (_) {
        verify(() => mockSearchTvSeries.execute(tQuery)).called(1);
      },
    );

    blocTest<TvSeriesSearchCubit, TvSeriesSearchState>(
      'should emit Loading then Error when search fails',
      build: () {
        when(
          () => mockSearchTvSeries.execute(tQuery),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return cubit;
      },
      act: (cubit) => cubit.fetchTvSeriesSearch(tQuery),
      expect: () => [
        const TvSeriesSearchState(state: RequestState.Loading, message: ''),
        const TvSeriesSearchState(
          state: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
    );
  });
}

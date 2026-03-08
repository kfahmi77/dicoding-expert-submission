import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tv_series.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series_list/tv_series_list_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockGetOnTheAirTvSeries extends Mock implements GetOnTheAirTvSeries {}

class MockGetPopularTvSeries extends Mock implements GetPopularTvSeries {}

class MockGetTopRatedTvSeries extends Mock implements GetTopRatedTvSeries {}

void main() {
  late TvSeriesListCubit cubit;
  late MockGetOnTheAirTvSeries mockGetOnTheAirTvSeries;
  late MockGetPopularTvSeries mockGetPopularTvSeries;
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;

  setUp(() {
    mockGetOnTheAirTvSeries = MockGetOnTheAirTvSeries();
    mockGetPopularTvSeries = MockGetPopularTvSeries();
    mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();
    cubit = TvSeriesListCubit(
      getOnTheAirTvSeries: mockGetOnTheAirTvSeries,
      getPopularTvSeries: mockGetPopularTvSeries,
      getTopRatedTvSeries: mockGetTopRatedTvSeries,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('fetchOnTheAirTvSeries', () {
    blocTest<TvSeriesListCubit, TvSeriesListState>(
      'should emit Loading then Loaded when success',
      build: () {
        when(
          () => mockGetOnTheAirTvSeries.execute(),
        ).thenAnswer((_) async => Right(testTvSeriesList));
        return cubit;
      },
      act: (cubit) => cubit.fetchOnTheAirTvSeries(),
      expect: () => [
        const TvSeriesListState(
          onTheAirState: RequestState.Loading,
          message: '',
        ),
        TvSeriesListState(
          onTheAirState: RequestState.Loaded,
          onTheAirTvSeries: testTvSeriesList,
        ),
      ],
    );

    blocTest<TvSeriesListCubit, TvSeriesListState>(
      'should emit Loading then Error when fails',
      build: () {
        when(
          () => mockGetOnTheAirTvSeries.execute(),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return cubit;
      },
      act: (cubit) => cubit.fetchOnTheAirTvSeries(),
      expect: () => [
        const TvSeriesListState(
          onTheAirState: RequestState.Loading,
          message: '',
        ),
        const TvSeriesListState(
          onTheAirState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
    );
  });

  group('fetchPopularTvSeries', () {
    blocTest<TvSeriesListCubit, TvSeriesListState>(
      'should emit Loading then Loaded when success',
      build: () {
        when(
          () => mockGetPopularTvSeries.execute(),
        ).thenAnswer((_) async => Right(testTvSeriesList));
        return cubit;
      },
      act: (cubit) => cubit.fetchPopularTvSeries(),
      expect: () => [
        const TvSeriesListState(
          popularTvSeriesState: RequestState.Loading,
          message: '',
        ),
        TvSeriesListState(
          popularTvSeriesState: RequestState.Loaded,
          popularTvSeries: testTvSeriesList,
        ),
      ],
    );

    blocTest<TvSeriesListCubit, TvSeriesListState>(
      'should emit Loading then Error when fails',
      build: () {
        when(
          () => mockGetPopularTvSeries.execute(),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return cubit;
      },
      act: (cubit) => cubit.fetchPopularTvSeries(),
      expect: () => [
        const TvSeriesListState(
          popularTvSeriesState: RequestState.Loading,
          message: '',
        ),
        const TvSeriesListState(
          popularTvSeriesState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
    );
  });

  group('fetchTopRatedTvSeries', () {
    blocTest<TvSeriesListCubit, TvSeriesListState>(
      'should emit Loading then Loaded when success',
      build: () {
        when(
          () => mockGetTopRatedTvSeries.execute(),
        ).thenAnswer((_) async => Right(testTvSeriesList));
        return cubit;
      },
      act: (cubit) => cubit.fetchTopRatedTvSeries(),
      expect: () => [
        const TvSeriesListState(
          topRatedTvSeriesState: RequestState.Loading,
          message: '',
        ),
        TvSeriesListState(
          topRatedTvSeriesState: RequestState.Loaded,
          topRatedTvSeries: testTvSeriesList,
        ),
      ],
    );

    blocTest<TvSeriesListCubit, TvSeriesListState>(
      'should emit Loading then Error when fails',
      build: () {
        when(
          () => mockGetTopRatedTvSeries.execute(),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return cubit;
      },
      act: (cubit) => cubit.fetchTopRatedTvSeries(),
      expect: () => [
        const TvSeriesListState(
          topRatedTvSeriesState: RequestState.Loading,
          message: '',
        ),
        const TvSeriesListState(
          topRatedTvSeriesState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
    );
  });
}

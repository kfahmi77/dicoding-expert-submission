import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/tv_series_search_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../helpers/test_helper.mocks.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  late TvSeriesSearchNotifier provider;
  late MockSearchTvSeries mockSearchTvSeries;

  setUp(() {
    mockSearchTvSeries = MockSearchTvSeries();
    provider = TvSeriesSearchNotifier(searchTvSeries: mockSearchTvSeries);
  });

  test('should change state to loading when usecase is called', () {
    when(
      mockSearchTvSeries.execute('TV Name'),
    ).thenAnswer((_) async => Right(testTvSeriesList));

    provider.fetchTvSeriesSearch('TV Name');

    expect(provider.state, RequestState.Loading);
  });

  test(
    'should update search result data when data is gotten successfully',
    () async {
      when(
        mockSearchTvSeries.execute('TV Name'),
      ).thenAnswer((_) async => Right(testTvSeriesList));

      await provider.fetchTvSeriesSearch('TV Name');

      expect(provider.state, RequestState.Loaded);
      expect(provider.searchResult, testTvSeriesList);
    },
  );

  test('should return error when data is unsuccessful', () async {
    when(
      mockSearchTvSeries.execute('TV Name'),
    ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));

    await provider.fetchTvSeriesSearch('TV Name');

    expect(provider.state, RequestState.Error);
    expect(provider.message, 'Server Failure');
  });
}

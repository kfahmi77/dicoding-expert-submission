import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../helpers/test_helper.mocks.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  late GetWatchlistTvSeries usecase;
  late MockTvSeriesRepository mockRepository;

  setUp(() {
    mockRepository = MockTvSeriesRepository();
    usecase = GetWatchlistTvSeries(mockRepository);
  });

  test('should get watchlist tv series from repository', () async {
    when(
      mockRepository.getWatchlistTvSeries(),
    ).thenAnswer((_) async => Right(testTvSeriesList));

    final result = await usecase.execute();

    expect(result, Right(testTvSeriesList));
  });
}

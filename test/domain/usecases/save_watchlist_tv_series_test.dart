import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../helpers/test_helper.mocks.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  late SaveWatchlistTvSeries usecase;
  late MockTvSeriesRepository mockRepository;

  setUp(() {
    mockRepository = MockTvSeriesRepository();
    usecase = SaveWatchlistTvSeries(mockRepository);
  });

  test('should save tv series to watchlist repository', () async {
    when(
      mockRepository.saveWatchlistTvSeries(testTvSeriesDetail),
    ).thenAnswer((_) async => const Right('Added to Watchlist'));

    final result = await usecase.execute(testTvSeriesDetail);

    expect(result, const Right('Added to Watchlist'));
  });
}

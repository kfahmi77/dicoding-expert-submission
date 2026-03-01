import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../helpers/test_helper.mocks.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  late RemoveWatchlistTvSeries usecase;
  late MockTvSeriesRepository mockRepository;

  setUp(() {
    mockRepository = MockTvSeriesRepository();
    usecase = RemoveWatchlistTvSeries(mockRepository);
  });

  test('should remove tv series from watchlist repository', () async {
    when(
      mockRepository.removeWatchlistTvSeries(testTvSeriesDetail),
    ).thenAnswer((_) async => const Right('Removed from Watchlist'));

    final result = await usecase.execute(testTvSeriesDetail);

    expect(result, const Right('Removed from Watchlist'));
  });
}

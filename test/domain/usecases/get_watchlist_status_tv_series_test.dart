import 'package:ditonton/domain/usecases/get_watchlist_status_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchlistStatusTvSeries usecase;
  late MockTvSeriesRepository mockRepository;

  setUp(() {
    mockRepository = MockTvSeriesRepository();
    usecase = GetWatchlistStatusTvSeries(mockRepository);
  });

  test('should get watchlist status from repository', () async {
    when(
      mockRepository.isAddedToWatchlistTvSeries(1),
    ).thenAnswer((_) async => true);

    final result = await usecase.execute(1);

    expect(result, true);
  });
}

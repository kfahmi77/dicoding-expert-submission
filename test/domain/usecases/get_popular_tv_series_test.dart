import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../helpers/test_helper.mocks.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  late GetPopularTvSeries usecase;
  late MockTvSeriesRepository mockRepository;

  setUp(() {
    mockRepository = MockTvSeriesRepository();
    usecase = GetPopularTvSeries(mockRepository);
  });

  test('should get popular tv series from repository', () async {
    when(
      mockRepository.getPopularTvSeries(),
    ).thenAnswer((_) async => Right(testTvSeriesList));

    final result = await usecase.execute();

    expect(result, Right(testTvSeriesList));
  });
}

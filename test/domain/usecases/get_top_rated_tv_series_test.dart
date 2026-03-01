import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../helpers/test_helper.mocks.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  late GetTopRatedTvSeries usecase;
  late MockTvSeriesRepository mockRepository;

  setUp(() {
    mockRepository = MockTvSeriesRepository();
    usecase = GetTopRatedTvSeries(mockRepository);
  });

  test('should get top rated tv series from repository', () async {
    when(
      mockRepository.getTopRatedTvSeries(),
    ).thenAnswer((_) async => Right(testTvSeriesList));

    final result = await usecase.execute();

    expect(result, Right(testTvSeriesList));
  });
}

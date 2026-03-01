import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../helpers/test_helper.mocks.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  late GetTvSeriesRecommendations usecase;
  late MockTvSeriesRepository mockRepository;

  setUp(() {
    mockRepository = MockTvSeriesRepository();
    usecase = GetTvSeriesRecommendations(mockRepository);
  });

  test('should get tv recommendations from repository', () async {
    when(
      mockRepository.getTvSeriesRecommendations(100),
    ).thenAnswer((_) async => Right(testTvSeriesList));

    final result = await usecase.execute(100);

    expect(result, Right(testTvSeriesList));
  });
}

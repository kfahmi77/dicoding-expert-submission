import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../helpers/test_helper.mocks.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  late GetTvSeriesDetail usecase;
  late MockTvSeriesRepository mockRepository;

  setUp(() {
    mockRepository = MockTvSeriesRepository();
    usecase = GetTvSeriesDetail(mockRepository);
  });

  test('should get tv detail from repository', () async {
    when(
      mockRepository.getTvSeriesDetail(100),
    ).thenAnswer((_) async => Right(testTvSeriesDetail));

    final result = await usecase.execute(100);

    expect(result, Right(testTvSeriesDetail));
  });
}

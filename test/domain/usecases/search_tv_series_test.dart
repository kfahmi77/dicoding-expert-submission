import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../helpers/test_helper.mocks.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  late SearchTvSeries usecase;
  late MockTvSeriesRepository mockRepository;

  setUp(() {
    mockRepository = MockTvSeriesRepository();
    usecase = SearchTvSeries(mockRepository);
  });

  test('should get tv search data from repository', () async {
    when(
      mockRepository.searchTvSeries('TV Name'),
    ).thenAnswer((_) async => Right(testTvSeriesList));

    final result = await usecase.execute('TV Name');

    expect(result, Right(testTvSeriesList));
  });
}

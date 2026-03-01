import 'dart:convert';

import 'package:ditonton/data/models/tv_series_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  test('fromJson should return valid model from JSON', () {
    final result = TvSeriesResponse.fromJson(
      json.decode(readJson('dummy_data/tv_on_the_air.json')),
    );

    expect(result.tvSeriesList, isNotEmpty);
    expect(result.tvSeriesList.first.id, 100);
  });

  test('toJson should return proper map', () {
    final model = TvSeriesResponse.fromJson(
      json.decode(readJson('dummy_data/tv_on_the_air.json')),
    );

    final result = model.toJson();

    expect(result['results'], isA<List<dynamic>>());
    expect((result['results'] as List).isNotEmpty, true);
  });
}

import 'dart:convert';

import 'package:ditonton/data/models/tv_series_detail_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tModel = TvSeriesDetailResponse.fromJson(
    json.decode(readJson('dummy_data/tv_detail.json')),
  );

  test('fromJson should return valid detail model', () {
    expect(tModel.id, 100);
    expect(tModel.name, 'TV Name');
    expect(tModel.numberOfEpisodes, 10);
  });

  test('toJson should return map containing proper data', () {
    final result = tModel.toJson();
    expect(result['id'], 100);
    expect(result['name'], 'TV Name');
    expect(result['number_of_seasons'], 1);
  });
}

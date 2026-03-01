import 'dart:convert';

import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tv_series_remote_data_source.dart';
import 'package:ditonton/data/models/tv_series_detail_model.dart';
import 'package:ditonton/data/models/tv_series_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  const apiKey = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const baseUrl = 'https://api.themoviedb.org/3';

  late TvSeriesRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TvSeriesRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get on the air tv series', () {
    final tTvList = TvSeriesResponse.fromJson(
      json.decode(readJson('dummy_data/tv_on_the_air.json')),
    ).tvSeriesList;

    test('should return list when response code is 200', () async {
      when(
        mockHttpClient.get(Uri.parse('$baseUrl/tv/on_the_air?$apiKey')),
      ).thenAnswer(
        (_) async =>
            http.Response(readJson('dummy_data/tv_on_the_air.json'), 200),
      );

      final result = await dataSource.getOnTheAirTvSeries();

      expect(result, tTvList);
    });

    test(
      'should throw ServerException when response code is not 200',
      () async {
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/tv/on_the_air?$apiKey')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));

        final call = dataSource.getOnTheAirTvSeries();

        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get popular tv series', () {
    final tTvList = TvSeriesResponse.fromJson(
      json.decode(readJson('dummy_data/tv_popular.json')),
    ).tvSeriesList;

    test('should return list when response code is 200', () async {
      when(
        mockHttpClient.get(Uri.parse('$baseUrl/tv/popular?$apiKey')),
      ).thenAnswer(
        (_) async => http.Response(readJson('dummy_data/tv_popular.json'), 200),
      );

      final result = await dataSource.getPopularTvSeries();

      expect(result, tTvList);
    });

    test(
      'should throw ServerException when response code is not 200',
      () async {
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/tv/popular?$apiKey')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));

        final call = dataSource.getPopularTvSeries();

        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get top rated tv series', () {
    final tTvList = TvSeriesResponse.fromJson(
      json.decode(readJson('dummy_data/tv_top_rated.json')),
    ).tvSeriesList;

    test('should return list when response code is 200', () async {
      when(
        mockHttpClient.get(Uri.parse('$baseUrl/tv/top_rated?$apiKey')),
      ).thenAnswer(
        (_) async =>
            http.Response(readJson('dummy_data/tv_top_rated.json'), 200),
      );

      final result = await dataSource.getTopRatedTvSeries();

      expect(result, tTvList);
    });

    test(
      'should throw ServerException when response code is not 200',
      () async {
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/tv/top_rated?$apiKey')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));

        final call = dataSource.getTopRatedTvSeries();

        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get tv detail', () {
    const tId = 100;
    final tDetail = TvSeriesDetailResponse.fromJson(
      json.decode(readJson('dummy_data/tv_detail.json')),
    );

    test('should return detail when response code is 200', () async {
      when(
        mockHttpClient.get(Uri.parse('$baseUrl/tv/$tId?$apiKey')),
      ).thenAnswer(
        (_) async => http.Response(readJson('dummy_data/tv_detail.json'), 200),
      );

      final result = await dataSource.getTvSeriesDetail(tId);

      expect(result, tDetail);
    });

    test(
      'should throw ServerException when response code is not 200',
      () async {
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/tv/$tId?$apiKey')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));

        final call = dataSource.getTvSeriesDetail(tId);

        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get tv recommendations', () {
    const tId = 100;
    final tTvList = TvSeriesResponse.fromJson(
      json.decode(readJson('dummy_data/tv_recommendations.json')),
    ).tvSeriesList;

    test('should return list when response code is 200', () async {
      when(
        mockHttpClient.get(
          Uri.parse('$baseUrl/tv/$tId/recommendations?$apiKey'),
        ),
      ).thenAnswer(
        (_) async =>
            http.Response(readJson('dummy_data/tv_recommendations.json'), 200),
      );

      final result = await dataSource.getTvSeriesRecommendations(tId);

      expect(result, tTvList);
    });

    test(
      'should throw ServerException when response code is not 200',
      () async {
        when(
          mockHttpClient.get(
            Uri.parse('$baseUrl/tv/$tId/recommendations?$apiKey'),
          ),
        ).thenAnswer((_) async => http.Response('Not Found', 404));

        final call = dataSource.getTvSeriesRecommendations(tId);

        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('search tv series', () {
    const query = 'TV Name';
    final tTvList = TvSeriesResponse.fromJson(
      json.decode(readJson('dummy_data/search_tv.json')),
    ).tvSeriesList;

    test('should return list when response code is 200', () async {
      when(
        mockHttpClient.get(
          Uri.parse('$baseUrl/search/tv?$apiKey&query=$query'),
        ),
      ).thenAnswer(
        (_) async => http.Response(readJson('dummy_data/search_tv.json'), 200),
      );

      final result = await dataSource.searchTvSeries(query);

      expect(result, tTvList);
    });

    test(
      'should throw ServerException when response code is not 200',
      () async {
        when(
          mockHttpClient.get(
            Uri.parse('$baseUrl/search/tv?$apiKey&query=$query'),
          ),
        ).thenAnswer((_) async => http.Response('Not Found', 404));

        final call = dataSource.searchTvSeries(query);

        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });
}

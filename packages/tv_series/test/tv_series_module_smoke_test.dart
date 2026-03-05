import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv_series/tv_series.dart';

void main() {
  test('tv series routes smoke test', () {
    final route = TvSeriesRoutes.onGenerateRoute(
      const RouteSettings(name: TvSeriesRoutes.home),
    );
    expect(route, isNotNull);
  });
}

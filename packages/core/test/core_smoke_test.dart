import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('core smoke test', () {
    expect(baseImageUrl, isNotEmpty);
    expect(routeObserver, isA<RouteObserver>());
    expect(DatabaseHelper.tblMovieWatchlist, equals('watchlist'));
  });
}

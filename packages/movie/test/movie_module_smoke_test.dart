import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie/movie.dart';

void main() {
  test('movie routes smoke test', () {
    final route = MovieRoutes.onGenerateRoute(
      const RouteSettings(name: MovieRoutes.home),
    );
    expect(route, isNotNull);
  });
}

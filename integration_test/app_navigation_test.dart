import 'package:ditonton/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('navigate from movie home to tv home and tv watchlist', (
    tester,
  ) async {
    app.main();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Ditonton'), findsOneWidget);

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pump(const Duration(milliseconds: 400));

    final tvSeriesMenu = find.widgetWithText(ListTile, 'TV Series');
    expect(tvSeriesMenu, findsOneWidget);
    await tester.tap(tvSeriesMenu);
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('TV Series'), findsWidgets);

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pump(const Duration(milliseconds: 400));

    final tvWatchlistMenu = find.widgetWithText(ListTile, 'Watchlist TV');
    expect(tvWatchlistMenu, findsOneWidget);
    await tester.tap(tvWatchlistMenu);
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Watchlist TV Series'), findsOneWidget);
  });
}

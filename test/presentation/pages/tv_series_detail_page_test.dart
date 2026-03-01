import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';
import 'package:ditonton/presentation/provider/tv_series_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../helpers/test_helper.mocks.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  late MockTvSeriesDetailNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockTvSeriesDetailNotifier();
  });

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TvSeriesDetailNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(home: body),
    );
  }

  testWidgets(
    'Watchlist button should display add icon when tv series not added',
    (WidgetTester tester) async {
      when(mockNotifier.tvSeriesState).thenReturn(RequestState.Loaded);
      when(mockNotifier.tvSeries).thenReturn(testTvSeriesDetail);
      when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
      when(mockNotifier.tvSeriesRecommendations).thenReturn(<TvSeries>[]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);

      final watchlistButtonIcon = find.byIcon(Icons.add);

      await tester.pumpWidget(
        makeTestableWidget(const TvSeriesDetailPage(id: 100)),
      );

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display check icon when tv series is added',
    (WidgetTester tester) async {
      when(mockNotifier.tvSeriesState).thenReturn(RequestState.Loaded);
      when(mockNotifier.tvSeries).thenReturn(testTvSeriesDetail);
      when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
      when(mockNotifier.tvSeriesRecommendations).thenReturn(<TvSeries>[]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(true);

      final watchlistButtonIcon = find.byIcon(Icons.check);

      await tester.pumpWidget(
        makeTestableWidget(const TvSeriesDetailPage(id: 100)),
      );

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets('Page should display season and episode information', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.tvSeriesState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvSeries).thenReturn(testTvSeriesDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvSeriesRecommendations).thenReturn(<TvSeries>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

    await tester.pumpWidget(
      makeTestableWidget(const TvSeriesDetailPage(id: 100)),
    );

    expect(find.text('Seasons & Episodes'), findsOneWidget);
    expect(find.byKey(const Key('season_episode_info')), findsOneWidget);
    expect(find.text('Seasons: 1 • Episodes: 10'), findsOneWidget);
  });

  testWidgets(
    'Page should display empty recommendation message when recommendation is empty',
    (WidgetTester tester) async {
      when(mockNotifier.tvSeriesState).thenReturn(RequestState.Loaded);
      when(mockNotifier.tvSeries).thenReturn(testTvSeriesDetail);
      when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
      when(mockNotifier.tvSeriesRecommendations).thenReturn(<TvSeries>[]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);

      await tester.pumpWidget(
        makeTestableWidget(const TvSeriesDetailPage(id: 100)),
      );

      expect(
        find.byKey(const Key('tv_series_recommendation_empty')),
        findsOneWidget,
      );
      expect(find.text('No recommendations available.'), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display Snackbar when added to watchlist',
    (WidgetTester tester) async {
      when(mockNotifier.tvSeriesState).thenReturn(RequestState.Loaded);
      when(mockNotifier.tvSeries).thenReturn(testTvSeriesDetail);
      when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
      when(mockNotifier.tvSeriesRecommendations).thenReturn(<TvSeries>[]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);
      when(mockNotifier.watchlistMessage).thenReturn('Added to Watchlist');

      final watchlistButton = find.byType(FilledButton);

      await tester.pumpWidget(
        makeTestableWidget(const TvSeriesDetailPage(id: 100)),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(watchlistButton);
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Added to Watchlist'), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display AlertDialog when add to watchlist failed',
    (WidgetTester tester) async {
      when(mockNotifier.tvSeriesState).thenReturn(RequestState.Loaded);
      when(mockNotifier.tvSeries).thenReturn(testTvSeriesDetail);
      when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
      when(mockNotifier.tvSeriesRecommendations).thenReturn(<TvSeries>[]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);
      when(mockNotifier.watchlistMessage).thenReturn('Failed');

      final watchlistButton = find.byType(FilledButton);

      await tester.pumpWidget(
        makeTestableWidget(const TvSeriesDetailPage(id: 100)),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(watchlistButton);
      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Failed'), findsOneWidget);
    },
  );
}

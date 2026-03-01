import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/provider/movie_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_detail_page_test.mocks.dart';

@GenerateMocks([MovieDetailNotifier])
void main() {
  late MockMovieDetailNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockMovieDetailNotifier();
  });

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<MovieDetailNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(home: body),
    );
  }

  testWidgets(
    'Watchlist button should display add icon when movie not added to watchlist',
    (WidgetTester tester) async {
      when(mockNotifier.movieState).thenReturn(RequestState.Loaded);
      when(mockNotifier.movie).thenReturn(testMovieDetail);
      when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
      when(mockNotifier.movieRecommendations).thenReturn(<Movie>[]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);

      final watchlistButtonIcon = find.byIcon(Icons.add);

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should dispay check icon when movie is added to wathclist',
    (WidgetTester tester) async {
      when(mockNotifier.movieState).thenReturn(RequestState.Loaded);
      when(mockNotifier.movie).thenReturn(testMovieDetail);
      when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
      when(mockNotifier.movieRecommendations).thenReturn(<Movie>[]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(true);

      final watchlistButtonIcon = find.byIcon(Icons.check);

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display Snackbar when added to watchlist',
    (WidgetTester tester) async {
      when(mockNotifier.movieState).thenReturn(RequestState.Loaded);
      when(mockNotifier.movie).thenReturn(testMovieDetail);
      when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
      when(mockNotifier.movieRecommendations).thenReturn(<Movie>[]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);
      when(mockNotifier.watchlistMessage).thenReturn('Added to Watchlist');

      final watchlistButton = find.byType(FilledButton);

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(watchlistButton);
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Added to Watchlist'), findsOneWidget);
    },
  );

  testWidgets('Page should display movie release and duration information', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.movieState).thenReturn(RequestState.Loaded);
    when(mockNotifier.movie).thenReturn(testMovieDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.movieRecommendations).thenReturn(<Movie>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.text('Release & Duration'), findsOneWidget);
    expect(find.byKey(const Key('movie_release_duration_info')), findsOneWidget);
    expect(
      find.text('Release: releaseDate • Duration: 2h 0m'),
      findsOneWidget,
    );
  });

  testWidgets(
    'Page should display empty recommendation message when recommendation is empty',
    (WidgetTester tester) async {
      when(mockNotifier.movieState).thenReturn(RequestState.Loaded);
      when(mockNotifier.movie).thenReturn(testMovieDetail);
      when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
      when(mockNotifier.movieRecommendations).thenReturn(<Movie>[]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

      expect(find.byKey(const Key('movie_recommendation_empty')), findsOneWidget);
      expect(find.text('No recommendations available.'), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display AlertDialog when add to watchlist failed',
    (WidgetTester tester) async {
      when(mockNotifier.movieState).thenReturn(RequestState.Loaded);
      when(mockNotifier.movie).thenReturn(testMovieDetail);
      when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
      when(mockNotifier.movieRecommendations).thenReturn(<Movie>[]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);
      when(mockNotifier.watchlistMessage).thenReturn('Failed');

      final watchlistButton = find.byType(FilledButton);

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(watchlistButton);
      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Failed'), findsOneWidget);
    },
  );
}

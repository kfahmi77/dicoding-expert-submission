import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_cubit.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockMovieDetailCubit extends MockCubit<MovieDetailState>
    implements MovieDetailCubit {}

void main() {
  late MockMovieDetailCubit mockCubit;
  late StreamController<MovieDetailState> stateController;
  late MovieDetailState currentState;

  setUpAll(() {
    registerFallbackValue(testMovieDetail);
  });

  setUp(() {
    mockCubit = MockMovieDetailCubit();
    stateController = StreamController<MovieDetailState>.broadcast();
    currentState = const MovieDetailState(
      movieState: RequestState.Loaded,
      recommendationState: RequestState.Loaded,
      movieRecommendations: <Movie>[],
      isAddedToWatchlist: false,
    ).copyWith(movie: testMovieDetail);

    when(() => mockCubit.state).thenAnswer((_) => currentState);
    whenListen(mockCubit, stateController.stream, initialState: currentState);

    when(() => mockCubit.fetchMovieDetail(any())).thenAnswer((_) async {});
    when(() => mockCubit.loadWatchlistStatus(any())).thenAnswer((_) async {});
    when(() => mockCubit.addWatchlist(any())).thenAnswer((_) async {});
    when(() => mockCubit.removeFromWatchlist(any())).thenAnswer((_) async {});
  });

  tearDown(() async {
    await stateController.close();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<MovieDetailCubit>.value(
      value: mockCubit,
      child: MaterialApp(home: body),
    );
  }

  testWidgets(
    'Watchlist button should display add icon when movie not added to watchlist',
    (WidgetTester tester) async {
      currentState = currentState.copyWith(isAddedToWatchlist: false);

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

      expect(find.byIcon(Icons.add), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should dispay check icon when movie is added to wathclist',
    (WidgetTester tester) async {
      currentState = currentState.copyWith(isAddedToWatchlist: true);

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
      stateController.add(currentState);
      await tester.pump();

      expect(find.byIcon(Icons.check), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display Snackbar when added to watchlist',
    (WidgetTester tester) async {
      when(() => mockCubit.addWatchlist(any())).thenAnswer((_) async {
        currentState = currentState.copyWith(
          watchlistMessage: MovieDetailCubit.watchlistAddSuccessMessage,
          isAddedToWatchlist: true,
        );
        stateController.add(currentState);
      });

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
      await tester.tap(find.byType(FilledButton));
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.text(MovieDetailCubit.watchlistAddSuccessMessage),
        findsOneWidget,
      );
    },
  );

  testWidgets('Page should display movie release and duration information', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(find.text('Release & Duration'), findsOneWidget);
    expect(
      find.byKey(const Key('movie_release_duration_info')),
      findsOneWidget,
    );
    expect(find.text('Release: releaseDate • Duration: 2h 0m'), findsOneWidget);
  });

  testWidgets(
    'Page should display empty recommendation message when recommendation is empty',
    (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

      expect(
        find.byKey(const Key('movie_recommendation_empty')),
        findsOneWidget,
      );
      expect(find.text('No recommendations available.'), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display AlertDialog when add to watchlist failed',
    (WidgetTester tester) async {
      when(() => mockCubit.addWatchlist(any())).thenAnswer((_) async {
        currentState = currentState.copyWith(watchlistMessage: 'Failed');
        stateController.add(currentState);
      });

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
      await tester.tap(find.byType(FilledButton));
      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Failed'), findsOneWidget);
    },
  );
}

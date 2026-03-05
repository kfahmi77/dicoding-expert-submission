import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series_detail/tv_series_detail_cubit.dart';
import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockTvSeriesDetailCubit extends MockCubit<TvSeriesDetailState>
    implements TvSeriesDetailCubit {}

void main() {
  late MockTvSeriesDetailCubit mockCubit;
  late StreamController<TvSeriesDetailState> stateController;
  late TvSeriesDetailState currentState;

  setUpAll(() {
    registerFallbackValue(testTvSeriesDetail);
  });

  setUp(() {
    mockCubit = MockTvSeriesDetailCubit();
    stateController = StreamController<TvSeriesDetailState>.broadcast();
    currentState = const TvSeriesDetailState(
      tvSeriesState: RequestState.Loaded,
      recommendationState: RequestState.Loaded,
      tvSeriesRecommendations: <TvSeries>[],
      isAddedToWatchlist: false,
    ).copyWith(tvSeries: testTvSeriesDetail);

    when(() => mockCubit.state).thenAnswer((_) => currentState);
    whenListen(mockCubit, stateController.stream, initialState: currentState);

    when(() => mockCubit.fetchTvSeriesDetail(any())).thenAnswer((_) async {});
    when(() => mockCubit.loadWatchlistStatus(any())).thenAnswer((_) async {});
    when(() => mockCubit.addWatchlist(any())).thenAnswer((_) async {});
    when(() => mockCubit.removeFromWatchlist(any())).thenAnswer((_) async {});
  });

  tearDown(() async {
    await stateController.close();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TvSeriesDetailCubit>.value(
      value: mockCubit,
      child: MaterialApp(home: body),
    );
  }

  testWidgets(
    'Watchlist button should display add icon when tv series not added',
    (WidgetTester tester) async {
      currentState = currentState.copyWith(isAddedToWatchlist: false);

      await tester.pumpWidget(
        makeTestableWidget(const TvSeriesDetailPage(id: 100)),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display check icon when tv series is added',
    (WidgetTester tester) async {
      currentState = currentState.copyWith(isAddedToWatchlist: true);

      await tester.pumpWidget(
        makeTestableWidget(const TvSeriesDetailPage(id: 100)),
      );
      stateController.add(currentState);
      await tester.pump();

      expect(find.byIcon(Icons.check), findsOneWidget);
    },
  );

  testWidgets('Page should display season and episode information', (
    WidgetTester tester,
  ) async {
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
      when(() => mockCubit.addWatchlist(any())).thenAnswer((_) async {
        currentState = currentState.copyWith(
          watchlistMessage: TvSeriesDetailCubit.watchlistAddSuccessMessage,
          isAddedToWatchlist: true,
        );
        stateController.add(currentState);
      });

      await tester.pumpWidget(
        makeTestableWidget(const TvSeriesDetailPage(id: 100)),
      );
      await tester.tap(find.byType(FilledButton));
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.text(TvSeriesDetailCubit.watchlistAddSuccessMessage),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Watchlist button should display AlertDialog when add to watchlist failed',
    (WidgetTester tester) async {
      when(() => mockCubit.addWatchlist(any())).thenAnswer((_) async {
        currentState = currentState.copyWith(watchlistMessage: 'Failed');
        stateController.add(currentState);
      });

      await tester.pumpWidget(
        makeTestableWidget(const TvSeriesDetailPage(id: 100)),
      );
      await tester.tap(find.byType(FilledButton));
      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Failed'), findsOneWidget);
    },
  );
}

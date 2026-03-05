import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/tv_series_list/tv_series_list_cubit.dart';
import 'package:ditonton/presentation/pages/popular_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTvSeriesListCubit extends MockCubit<TvSeriesListState>
    implements TvSeriesListCubit {}

void main() {
  late MockTvSeriesListCubit mockCubit;

  setUp(() {
    mockCubit = MockTvSeriesListCubit();
    when(() => mockCubit.fetchPopularTvSeries()).thenAnswer((_) async {});
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TvSeriesListCubit>.value(
      value: mockCubit,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    WidgetTester tester,
  ) async {
    const state = TvSeriesListState(popularTvSeriesState: RequestState.Loading);
    when(() => mockCubit.state).thenReturn(state);
    whenListen(
      mockCubit,
      const Stream<TvSeriesListState>.empty(),
      initialState: state,
    );

    await tester.pumpWidget(makeTestableWidget(const PopularTvSeriesPage()));

    expect(find.byType(Center), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (
    WidgetTester tester,
  ) async {
    const state = TvSeriesListState(popularTvSeriesState: RequestState.Loaded);
    when(() => mockCubit.state).thenReturn(state);
    whenListen(
      mockCubit,
      const Stream<TvSeriesListState>.empty(),
      initialState: state,
    );

    await tester.pumpWidget(makeTestableWidget(const PopularTvSeriesPage()));

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (
    WidgetTester tester,
  ) async {
    const state = TvSeriesListState(
      popularTvSeriesState: RequestState.Error,
      message: 'Error message',
    );
    when(() => mockCubit.state).thenReturn(state);
    whenListen(
      mockCubit,
      const Stream<TvSeriesListState>.empty(),
      initialState: state,
    );

    await tester.pumpWidget(makeTestableWidget(const PopularTvSeriesPage()));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
  });
}

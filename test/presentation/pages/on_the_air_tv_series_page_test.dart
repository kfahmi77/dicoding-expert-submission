import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/pages/on_the_air_tv_series_page.dart';
import 'package:ditonton/presentation/provider/on_the_air_tv_series_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockOnTheAirTvSeriesNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockOnTheAirTvSeriesNotifier();
  });

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<OnTheAirTvSeriesNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.state).thenReturn(RequestState.Loading);

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget(const OnTheAirTvSeriesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.state).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvSeries).thenReturn(<TvSeries>[]);

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(const OnTheAirTvSeriesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.state).thenReturn(RequestState.Error);
    when(mockNotifier.message).thenReturn('Error message');

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(makeTestableWidget(const OnTheAirTvSeriesPage()));

    expect(textFinder, findsOneWidget);
  });
}

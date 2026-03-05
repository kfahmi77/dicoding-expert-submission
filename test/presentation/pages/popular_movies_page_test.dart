import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/movie_list/movie_list_cubit.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMovieListCubit extends MockCubit<MovieListState>
    implements MovieListCubit {}

void main() {
  late MockMovieListCubit mockCubit;

  setUp(() {
    mockCubit = MockMovieListCubit();
    when(() => mockCubit.fetchPopularMovies()).thenAnswer((_) async {});
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<MovieListCubit>.value(
      value: mockCubit,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    WidgetTester tester,
  ) async {
    const state = MovieListState(popularMoviesState: RequestState.Loading);
    when(() => mockCubit.state).thenReturn(state);
    whenListen(
      mockCubit,
      const Stream<MovieListState>.empty(),
      initialState: state,
    );

    await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));

    expect(find.byType(Center), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (
    WidgetTester tester,
  ) async {
    const state = MovieListState(popularMoviesState: RequestState.Loaded);
    when(() => mockCubit.state).thenReturn(state);
    whenListen(
      mockCubit,
      const Stream<MovieListState>.empty(),
      initialState: state,
    );

    await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (
    WidgetTester tester,
  ) async {
    const state = MovieListState(
      popularMoviesState: RequestState.Error,
      message: 'Error message',
    );
    when(() => mockCubit.state).thenReturn(state);
    whenListen(
      mockCubit,
      const Stream<MovieListState>.empty(),
      initialState: state,
    );

    await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
  });
}

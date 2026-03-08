import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockGetMovieDetail extends Mock implements GetMovieDetail {}

class MockGetMovieRecommendations extends Mock
    implements GetMovieRecommendations {}

class MockGetWatchListStatus extends Mock implements GetWatchListStatus {}

class MockSaveWatchlist extends Mock implements SaveWatchlist {}

class MockRemoveWatchlist extends Mock implements RemoveWatchlist {}

void main() {
  late MovieDetailCubit cubit;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    cubit = MovieDetailCubit(
      getMovieDetail: mockGetMovieDetail,
      getMovieRecommendations: mockGetMovieRecommendations,
      getWatchListStatus: mockGetWatchListStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  tearDown(() {
    cubit.close();
  });

  const tId = 1;
  final tMovies = <Movie>[testMovie];

  group('fetchMovieDetail', () {
    void arrangeSuccess() {
      when(
        () => mockGetMovieDetail.execute(tId),
      ).thenAnswer((_) async => Right(testMovieDetail));
      when(
        () => mockGetMovieRecommendations.execute(tId),
      ).thenAnswer((_) async => Right(tMovies));
    }

    blocTest<MovieDetailCubit, MovieDetailState>(
      'should emit Loading then Loaded when detail and recommendations succeed',
      build: () {
        arrangeSuccess();
        return cubit;
      },
      act: (cubit) => cubit.fetchMovieDetail(tId),
      expect: () => [
        const MovieDetailState(
          movieState: RequestState.Loading,
          recommendationState: RequestState.Empty,
          message: '',
        ),
        MovieDetailState(
          movie: testMovieDetail,
          movieState: RequestState.Loading,
          recommendationState: RequestState.Loading,
          message: '',
        ),
        MovieDetailState(
          movie: testMovieDetail,
          movieState: RequestState.Loaded,
          recommendationState: RequestState.Loaded,
          movieRecommendations: tMovies,
          message: '',
        ),
      ],
      verify: (_) {
        verify(() => mockGetMovieDetail.execute(tId)).called(1);
        verify(() => mockGetMovieRecommendations.execute(tId)).called(1);
      },
    );

    blocTest<MovieDetailCubit, MovieDetailState>(
      'should emit Error when getMovieDetail fails',
      build: () {
        when(
          () => mockGetMovieDetail.execute(tId),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(
          () => mockGetMovieRecommendations.execute(tId),
        ).thenAnswer((_) async => Right(tMovies));
        return cubit;
      },
      act: (cubit) => cubit.fetchMovieDetail(tId),
      expect: () => [
        const MovieDetailState(
          movieState: RequestState.Loading,
          recommendationState: RequestState.Empty,
          message: '',
        ),
        const MovieDetailState(
          movieState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
    );

    blocTest<MovieDetailCubit, MovieDetailState>(
      'should emit recommendation Error when getMovieRecommendations fails',
      build: () {
        when(
          () => mockGetMovieDetail.execute(tId),
        ).thenAnswer((_) async => Right(testMovieDetail));
        when(
          () => mockGetMovieRecommendations.execute(tId),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return cubit;
      },
      act: (cubit) => cubit.fetchMovieDetail(tId),
      expect: () => [
        const MovieDetailState(
          movieState: RequestState.Loading,
          recommendationState: RequestState.Empty,
          message: '',
        ),
        MovieDetailState(
          movie: testMovieDetail,
          movieState: RequestState.Loading,
          recommendationState: RequestState.Loading,
          message: '',
        ),
        MovieDetailState(
          movie: testMovieDetail,
          movieState: RequestState.Loaded,
          recommendationState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
    );
  });

  group('addWatchlist', () {
    blocTest<MovieDetailCubit, MovieDetailState>(
      'should emit watchlistMessage and update status when add watchlist succeeds',
      build: () {
        when(
          () => mockSaveWatchlist.execute(testMovieDetail),
        ).thenAnswer((_) async => const Right('Added to Watchlist'));
        when(
          () => mockGetWatchListStatus.execute(testMovieDetail.id),
        ).thenAnswer((_) async => true);
        return cubit;
      },
      act: (cubit) => cubit.addWatchlist(testMovieDetail),
      expect: () => [
        const MovieDetailState(watchlistMessage: 'Added to Watchlist'),
        const MovieDetailState(
          watchlistMessage: 'Added to Watchlist',
          isAddedToWatchlist: true,
        ),
      ],
    );

    blocTest<MovieDetailCubit, MovieDetailState>(
      'should emit failure message when add watchlist fails',
      build: () {
        when(() => mockSaveWatchlist.execute(testMovieDetail)).thenAnswer(
          (_) async => Left(DatabaseFailure('Failed to add watchlist')),
        );
        when(
          () => mockGetWatchListStatus.execute(testMovieDetail.id),
        ).thenAnswer((_) async => false);
        return cubit;
      },
      act: (cubit) => cubit.addWatchlist(testMovieDetail),
      expect: () => [
        const MovieDetailState(watchlistMessage: 'Failed to add watchlist'),
      ],
    );
  });

  group('removeFromWatchlist', () {
    blocTest<MovieDetailCubit, MovieDetailState>(
      'should emit watchlistMessage and update status when remove succeeds',
      build: () {
        when(
          () => mockRemoveWatchlist.execute(testMovieDetail),
        ).thenAnswer((_) async => const Right('Removed from Watchlist'));
        when(
          () => mockGetWatchListStatus.execute(testMovieDetail.id),
        ).thenAnswer((_) async => false);
        return cubit;
      },
      act: (cubit) => cubit.removeFromWatchlist(testMovieDetail),
      expect: () => [
        const MovieDetailState(watchlistMessage: 'Removed from Watchlist'),
      ],
    );
  });

  group('loadWatchlistStatus', () {
    blocTest<MovieDetailCubit, MovieDetailState>(
      'should emit isAddedToWatchlist true',
      build: () {
        when(
          () => mockGetWatchListStatus.execute(tId),
        ).thenAnswer((_) async => true);
        return cubit;
      },
      act: (cubit) => cubit.loadWatchlistStatus(tId),
      expect: () => [const MovieDetailState(isAddedToWatchlist: true)],
    );

    blocTest<MovieDetailCubit, MovieDetailState>(
      'should emit isAddedToWatchlist false',
      build: () {
        when(
          () => mockGetWatchListStatus.execute(tId),
        ).thenAnswer((_) async => false);
        return cubit;
      },
      act: (cubit) => cubit.loadWatchlistStatus(tId),
      expect: () => [const MovieDetailState(isAddedToWatchlist: false)],
    );
  });
}

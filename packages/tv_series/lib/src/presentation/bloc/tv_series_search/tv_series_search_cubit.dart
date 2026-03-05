import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/common/state_enum.dart';
import 'package:tv_series/src/domain/entities/tv_series.dart';
import 'package:tv_series/src/domain/usecases/search_tv_series.dart';
import 'package:equatable/equatable.dart';

class TvSeriesSearchState extends Equatable {
  const TvSeriesSearchState({
    this.state = RequestState.Empty,
    this.searchResult = const <TvSeries>[],
    this.message = '',
  });

  final RequestState state;
  final List<TvSeries> searchResult;
  final String message;

  TvSeriesSearchState copyWith({
    RequestState? state,
    List<TvSeries>? searchResult,
    String? message,
  }) {
    return TvSeriesSearchState(
      state: state ?? this.state,
      searchResult: searchResult ?? this.searchResult,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [state, searchResult, message];
}

class TvSeriesSearchCubit extends Cubit<TvSeriesSearchState> {
  TvSeriesSearchCubit({required this.searchTvSeries})
    : super(const TvSeriesSearchState());

  final SearchTvSeries searchTvSeries;

  Future<void> fetchTvSeriesSearch(String query) async {
    emit(state.copyWith(state: RequestState.Loading, message: ''));

    final result = await searchTvSeries.execute(query);
    result.fold(
      (failure) => emit(
        state.copyWith(state: RequestState.Error, message: failure.message),
      ),
      (data) =>
          emit(state.copyWith(state: RequestState.Loaded, searchResult: data)),
    );
  }
}

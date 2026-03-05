import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:tv_series/src/domain/entities/tv_series_detail.dart';
import 'package:tv_series/src/domain/repositories/tv_series_repository.dart';

class RemoveWatchlistTvSeries {
  final TvSeriesRepository repository;

  RemoveWatchlistTvSeries(this.repository);

  Future<Either<Failure, String>> execute(TvSeriesDetail tvSeries) {
    return repository.removeWatchlistTvSeries(tvSeries);
  }
}

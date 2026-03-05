import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:tv_series/src/domain/entities/tv_series.dart';
import 'package:tv_series/src/domain/repositories/tv_series_repository.dart';

class GetWatchlistTvSeries {
  final TvSeriesRepository repository;

  GetWatchlistTvSeries(this.repository);

  Future<Either<Failure, List<TvSeries>>> execute() {
    return repository.getWatchlistTvSeries();
  }
}

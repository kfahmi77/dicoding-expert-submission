import 'package:dartz/dartz.dart';
import 'package:movie/src/domain/entities/movie.dart';
import 'package:movie/src/domain/repositories/movie_repository.dart';
import 'package:core/common/failure.dart';

class GetMovieRecommendations {
  final MovieRepository repository;

  GetMovieRecommendations(this.repository);

  Future<Either<Failure, List<Movie>>> execute(int id) {
    return repository.getMovieRecommendations(id);
  }
}

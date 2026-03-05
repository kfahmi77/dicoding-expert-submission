import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/common/constants.dart';
import 'package:core/common/state_enum.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:movie/src/domain/entities/movie.dart';
import 'package:movie/src/domain/entities/movie_detail.dart';
import 'package:movie/src/presentation/bloc/movie_detail/movie_detail_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MovieDetailPage extends StatefulWidget {
  static const routeName = '/detail';

  const MovieDetailPage({super.key, required this.id});

  final int id;

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final cubit = context.read<MovieDetailCubit>();
      cubit.fetchMovieDetail(widget.id);
      cubit.loadWatchlistStatus(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MovieDetailCubit, MovieDetailState>(
        builder: (context, state) {
          if (state.movieState == RequestState.Loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.movieState == RequestState.Loaded && state.movie != null) {
            return SafeArea(
              child: DetailContent(
                movie: state.movie!,
                recommendations: state.movieRecommendations,
                isAddedWatchlist: state.isAddedToWatchlist,
                recommendationState: state.recommendationState,
                message: state.message,
              ),
            );
          }
          return Center(child: Text(state.message));
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  const DetailContent({
    super.key,
    required this.movie,
    required this.recommendations,
    required this.isAddedWatchlist,
    required this.recommendationState,
    required this.message,
  });

  final MovieDetail movie;
  final List<Movie> recommendations;
  final bool isAddedWatchlist;
  final RequestState recommendationState;
  final String message;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: '$baseImageUrl${movie.posterPath}',
          width: screenWidth,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 56),
          child: DraggableScrollableSheet(
            minChildSize: 0.25,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(movie.title, style: kHeading5),
                            const SizedBox(height: 12),
                            FilledButton(
                              onPressed: () async {
                                final cubit = context.read<MovieDetailCubit>();
                                if (!isAddedWatchlist) {
                                  await cubit.addWatchlist(movie);
                                } else {
                                  await cubit.removeFromWatchlist(movie);
                                }

                                if (!context.mounted) return;
                                final watchlistMessage =
                                    cubit.state.watchlistMessage;

                                if (watchlistMessage ==
                                        MovieDetailCubit
                                            .watchlistAddSuccessMessage ||
                                    watchlistMessage ==
                                        MovieDetailCubit
                                            .watchlistRemoveSuccessMessage) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(watchlistMessage)),
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Text(watchlistMessage),
                                      );
                                    },
                                  );
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isAddedWatchlist
                                      ? const Icon(Icons.check)
                                      : const Icon(Icons.add),
                                  const Text('Watchlist'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(_showGenres(movie.genres)),
                            const SizedBox(height: 16),
                            Text('Release & Duration', style: kHeading6),
                            const SizedBox(height: 4),
                            Text(
                              'Release: ${movie.releaseDate} \u2022 Duration: ${_showDuration(movie.runtime)}',
                              key: const Key('movie_release_duration_info'),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: movie.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${movie.voteAverage}'),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text('Overview', style: kHeading6),
                            const SizedBox(height: 8),
                            Text(movie.overview),
                            const SizedBox(height: 20),
                            Text('Recommendations', style: kHeading6),
                            const SizedBox(height: 8),
                            if (recommendationState == RequestState.Loading)
                              const Center(child: CircularProgressIndicator())
                            else if (recommendationState == RequestState.Error)
                              Text(message)
                            else if (recommendationState == RequestState.Loaded)
                              recommendations.isEmpty
                                  ? const Text(
                                      'No recommendations available.',
                                      key: Key('movie_recommendation_empty'),
                                    )
                                  : SizedBox(
                                      height: 150,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: recommendations.length,
                                        itemBuilder: (context, index) {
                                          final recommendation =
                                              recommendations[index];
                                          return Padding(
                                            padding: const EdgeInsets.all(4),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.pushReplacementNamed(
                                                  context,
                                                  MovieDetailPage.routeName,
                                                  arguments: recommendation.id,
                                                );
                                              },
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                      Radius.circular(8),
                                                    ),
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      '$baseImageUrl${recommendation.posterPath}',
                                                  placeholder: (context, url) =>
                                                      const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          const Icon(
                                                            Icons.error,
                                                          ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                            else
                              const SizedBox(),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    final result = genres.map((genre) => genre.name).join(', ');
    return result;
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/presentation/provider/tv_series_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class TvSeriesDetailPage extends StatefulWidget {
  static const routeName = '/detail-tv-series';

  const TvSeriesDetailPage({super.key, required this.id});

  final int id;

  @override
  State<TvSeriesDetailPage> createState() => _TvSeriesDetailPageState();
}

class _TvSeriesDetailPageState extends State<TvSeriesDetailPage> {
  bool _hasLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasLoaded) {
      final notifier = context.read<TvSeriesDetailNotifier>();
      notifier.fetchTvSeriesDetail(widget.id);
      notifier.loadWatchlistStatus(widget.id);
      _hasLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TvSeriesDetailNotifier>(
        builder: (context, provider, child) {
          if (provider.tvSeriesState == RequestState.Loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.tvSeriesState == RequestState.Loaded) {
            return SafeArea(
              child: _DetailContent(
                provider.tvSeries,
                provider.tvSeriesRecommendations,
                provider.isAddedToWatchlist,
              ),
            );
          }
          return Text(provider.message);
        },
      ),
    );
  }
}

class _DetailContent extends StatelessWidget {
  const _DetailContent(
    this.tvSeries,
    this.recommendations,
    this.isAddedWatchlist,
  );

  final TvSeriesDetail tvSeries;
  final List<TvSeries> recommendations;
  final bool isAddedWatchlist;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: '$baseImageUrl${tvSeries.posterPath}',
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
                            Text(tvSeries.name, style: kHeading5),
                            const SizedBox(height: 12),
                            FilledButton(
                              onPressed: () async {
                                final notifier = context
                                    .read<TvSeriesDetailNotifier>();
                                if (!isAddedWatchlist) {
                                  await notifier.addWatchlist(tvSeries);
                                } else {
                                  await notifier.removeFromWatchlist(tvSeries);
                                }

                                if (!context.mounted) return;
                                final message = notifier.watchlistMessage;

                                if (message ==
                                        TvSeriesDetailNotifier
                                            .watchlistAddSuccessMessage ||
                                    message ==
                                        TvSeriesDetailNotifier
                                            .watchlistRemoveSuccessMessage) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(message)),
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Text(message),
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
                            Text(_showGenres(tvSeries.genres)),
                            const SizedBox(height: 16),
                            Text('Seasons & Episodes', style: kHeading6),
                            const SizedBox(height: 4),
                            Text(
                              'Seasons: ${tvSeries.numberOfSeasons} • Episodes: ${tvSeries.numberOfEpisodes}',
                              key: const Key('season_episode_info'),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tvSeries.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tvSeries.voteAverage}'),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text('Overview', style: kHeading6),
                            const SizedBox(height: 8),
                            Text(tvSeries.overview),
                            const SizedBox(height: 20),
                            Text('Recommendations', style: kHeading6),
                            const SizedBox(height: 8),
                            Consumer<TvSeriesDetailNotifier>(
                              builder: (context, data, child) {
                                if (data.recommendationState ==
                                    RequestState.Loading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if (data.recommendationState ==
                                    RequestState.Error) {
                                  return Text(data.message);
                                }
                                if (data.recommendationState ==
                                    RequestState.Loaded) {
                                  if (recommendations.isEmpty) {
                                    return const Text(
                                      'No recommendations available.',
                                      key: Key(
                                        'tv_series_recommendation_empty',
                                      ),
                                    );
                                  }
                                  return SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final item = recommendations[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                TvSeriesDetailPage.routeName,
                                                arguments: item.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                    Radius.circular(8),
                                                  ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    '$baseImageUrl${item.posterPath}',
                                                placeholder: (context, url) =>
                                                    const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: recommendations.length,
                                    ),
                                  );
                                }
                                return const SizedBox();
                              },
                            ),
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
}

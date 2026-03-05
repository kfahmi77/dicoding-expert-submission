import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/common/constants.dart';
import 'package:core/common/state_enum.dart';
import 'package:tv_series/src/domain/entities/tv_series.dart';
import 'package:tv_series/src/presentation/bloc/tv_series_list/tv_series_list_cubit.dart';
import 'package:tv_series/src/presentation/pages/popular_tv_series_page.dart';
import 'package:tv_series/src/presentation/pages/search_tv_series_page.dart';
import 'package:tv_series/src/presentation/pages/top_rated_tv_series_page.dart';
import 'package:tv_series/src/presentation/pages/tv_series_detail_page.dart';
import 'package:tv_series/src/presentation/pages/watchlist_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeTvSeriesPage extends StatefulWidget {
  const HomeTvSeriesPage({super.key});

  @override
  State<HomeTvSeriesPage> createState() => _HomeTvSeriesPageState();
}

class _HomeTvSeriesPageState extends State<HomeTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final cubit = context.read<TvSeriesListCubit>();
      cubit
        ..fetchOnTheAirTvSeries()
        ..fetchPopularTvSeries()
        ..fetchTopRatedTvSeries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: const AssetImage('assets/circle-g.png'),
                backgroundColor: Colors.grey.shade900,
              ),
              accountName: const Text('Ditonton'),
              accountEmail: const Text('ditonton@dicoding.com'),
              decoration: BoxDecoration(color: Colors.grey.shade900),
            ),
            ListTile(
              leading: const Icon(Icons.movie),
              title: const Text('Movies'),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home',
                  (route) => false,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.save_alt),
              title: const Text('Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, '/watchlist-movie');
              },
            ),
            ListTile(
              leading: const Icon(Icons.tv),
              title: const Text('TV Series'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.tv_off),
              title: const Text('Watchlist TV'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistTvSeriesPage.routeName);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              onTap: () {
                Navigator.pushNamed(context, '/about');
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('TV Series'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchTvSeriesPage.routeName);
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('On The Air', style: kHeading6),
              BlocBuilder<TvSeriesListCubit, TvSeriesListState>(
                builder: (context, state) {
                  if (state.onTheAirState == RequestState.Loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.onTheAirState == RequestState.Loaded) {
                    return _TvSeriesList(state.onTheAirTvSeries);
                  }
                  return Text(state.message);
                },
              ),
              _buildSubHeading(
                title: 'Popular',
                onTap: () {
                  Navigator.pushNamed(context, PopularTvSeriesPage.routeName);
                },
              ),
              BlocBuilder<TvSeriesListCubit, TvSeriesListState>(
                builder: (context, state) {
                  if (state.popularTvSeriesState == RequestState.Loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.popularTvSeriesState == RequestState.Loaded) {
                    return _TvSeriesList(state.popularTvSeries);
                  }
                  return Text(state.message);
                },
              ),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () {
                  Navigator.pushNamed(context, TopRatedTvSeriesPage.routeName);
                },
              ),
              BlocBuilder<TvSeriesListCubit, TvSeriesListState>(
                builder: (context, state) {
                  if (state.topRatedTvSeriesState == RequestState.Loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.topRatedTvSeriesState == RequestState.Loaded) {
                    return _TvSeriesList(state.topRatedTvSeries);
                  }
                  return Text(state.message);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubHeading({
    required String title,
    required VoidCallback onTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: kHeading6),
        InkWell(
          onTap: onTap,
          child: const Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class _TvSeriesList extends StatelessWidget {
  const _TvSeriesList(this.tvSeries);

  final List<TvSeries> tvSeries;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tvSeries.length,
        itemBuilder: (context, index) {
          final item = tvSeries[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TvSeriesDetailPage.routeName,
                  arguments: item.id,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$baseImageUrl${item.posterPath}',
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

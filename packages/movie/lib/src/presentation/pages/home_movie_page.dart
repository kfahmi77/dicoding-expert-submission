import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/common/constants.dart';
import 'package:core/common/state_enum.dart';
import 'package:movie/src/domain/entities/movie.dart';
import 'package:movie/src/presentation/bloc/movie_list/movie_list_cubit.dart';
import 'package:movie/src/presentation/pages/movie_detail_page.dart';
import 'package:movie/src/presentation/pages/popular_movies_page.dart';
import 'package:movie/src/presentation/pages/search_page.dart';
import 'package:movie/src/presentation/pages/top_rated_movies_page.dart';
import 'package:movie/src/presentation/pages/watchlist_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeMoviePage extends StatefulWidget {
  const HomeMoviePage({super.key});

  @override
  State<HomeMoviePage> createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final cubit = context.read<MovieListCubit>();
      cubit
        ..fetchNowPlayingMovies()
        ..fetchPopularMovies()
        ..fetchTopRatedMovies();
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
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.save_alt),
              title: const Text('Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistMoviesPage.routeName);
              },
            ),
            ListTile(
              leading: const Icon(Icons.tv),
              title: const Text('TV Series'),
              onTap: () {
                Navigator.pushNamed(context, '/home-tv');
              },
            ),
            ListTile(
              leading: const Icon(Icons.tv_off),
              title: const Text('Watchlist TV'),
              onTap: () {
                Navigator.pushNamed(context, '/watchlist-tv-series');
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, '/about');
              },
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Ditonton'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchPage.routeName);
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
              Text('Now Playing', style: kHeading6),
              BlocBuilder<MovieListCubit, MovieListState>(
                builder: (context, state) {
                  if (state.nowPlayingState == RequestState.Loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.nowPlayingState == RequestState.Loaded) {
                    return MovieList(state.nowPlayingMovies);
                  }
                  return Text(state.message.isEmpty ? 'Failed' : state.message);
                },
              ),
              _buildSubHeading(
                title: 'Popular',
                onTap: () {
                  Navigator.pushNamed(context, PopularMoviesPage.routeName);
                },
              ),
              BlocBuilder<MovieListCubit, MovieListState>(
                builder: (context, state) {
                  if (state.popularMoviesState == RequestState.Loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.popularMoviesState == RequestState.Loaded) {
                    return MovieList(state.popularMovies);
                  }
                  return Text(state.message.isEmpty ? 'Failed' : state.message);
                },
              ),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () {
                  Navigator.pushNamed(context, TopRatedMoviesPage.routeName);
                },
              ),
              BlocBuilder<MovieListCubit, MovieListState>(
                builder: (context, state) {
                  if (state.topRatedMoviesState == RequestState.Loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.topRatedMoviesState == RequestState.Loaded) {
                    return MovieList(state.topRatedMovies);
                  }
                  return Text(state.message.isEmpty ? 'Failed' : state.message);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required VoidCallback onTap}) {
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

class MovieList extends StatelessWidget {
  const MovieList(this.movies, {super.key});

  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  MovieDetailPage.routeName,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$baseImageUrl${movie.posterPath}',
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

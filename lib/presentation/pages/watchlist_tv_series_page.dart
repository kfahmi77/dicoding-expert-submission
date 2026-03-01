import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/provider/watchlist_tv_series_notifier.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchlistTvSeriesPage extends StatefulWidget {
  static const routeName = '/watchlist-tv-series';

  const WatchlistTvSeriesPage({super.key});

  @override
  State<WatchlistTvSeriesPage> createState() => _WatchlistTvSeriesPageState();
}

class _WatchlistTvSeriesPageState extends State<WatchlistTvSeriesPage>
    with RouteAware {
  bool _hasFetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasFetched) {
      context.read<WatchlistTvSeriesNotifier>().fetchWatchlistTvSeries();
      routeObserver.subscribe(this, ModalRoute.of(context)!);
      _hasFetched = true;
    }
  }

  @override
  void didPopNext() {
    context.read<WatchlistTvSeriesNotifier>().fetchWatchlistTvSeries();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Watchlist TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Consumer<WatchlistTvSeriesNotifier>(
          builder: (context, data, child) {
            if (data.watchlistState == RequestState.Loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (data.watchlistState == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvSeries = data.watchlistTvSeries[index];
                  return TvSeriesCard(tvSeries);
                },
                itemCount: data.watchlistTvSeries.length,
              );
            }
            return Center(
              key: const Key('error_message'),
              child: Text(data.message),
            );
          },
        ),
      ),
    );
  }
}

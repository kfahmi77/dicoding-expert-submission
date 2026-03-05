import 'package:core/common/state_enum.dart';
import 'package:tv_series/src/presentation/bloc/tv_series_list/tv_series_list_cubit.dart';
import 'package:tv_series/src/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedTvSeriesPage extends StatefulWidget {
  static const routeName = '/top-rated-tv-series';

  const TopRatedTvSeriesPage({super.key});

  @override
  State<TopRatedTvSeriesPage> createState() => _TopRatedTvSeriesPageState();
}

class _TopRatedTvSeriesPageState extends State<TopRatedTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<TvSeriesListCubit>().fetchTopRatedTvSeries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top Rated TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocBuilder<TvSeriesListCubit, TvSeriesListState>(
          builder: (context, state) {
            if (state.topRatedTvSeriesState == RequestState.Loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.topRatedTvSeriesState == RequestState.Loaded) {
              return ListView.builder(
                itemCount: state.topRatedTvSeries.length,
                itemBuilder: (context, index) {
                  final tv = state.topRatedTvSeries[index];
                  return TvSeriesCard(tv);
                },
              );
            }
            return Center(
              key: const Key('error_message'),
              child: Text(state.message),
            );
          },
        ),
      ),
    );
  }
}

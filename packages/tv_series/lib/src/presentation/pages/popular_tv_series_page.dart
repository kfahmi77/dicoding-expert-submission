import 'package:core/common/state_enum.dart';
import 'package:tv_series/src/presentation/bloc/tv_series_list/tv_series_list_cubit.dart';
import 'package:tv_series/src/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularTvSeriesPage extends StatefulWidget {
  static const routeName = '/popular-tv-series';

  const PopularTvSeriesPage({super.key});

  @override
  State<PopularTvSeriesPage> createState() => _PopularTvSeriesPageState();
}

class _PopularTvSeriesPageState extends State<PopularTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<TvSeriesListCubit>().fetchPopularTvSeries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Popular TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocBuilder<TvSeriesListCubit, TvSeriesListState>(
          builder: (context, state) {
            if (state.popularTvSeriesState == RequestState.Loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.popularTvSeriesState == RequestState.Loaded) {
              return ListView.builder(
                itemCount: state.popularTvSeries.length,
                itemBuilder: (context, index) {
                  final tv = state.popularTvSeries[index];
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

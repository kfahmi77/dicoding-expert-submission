import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/tv_series_list/tv_series_list_cubit.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnTheAirTvSeriesPage extends StatefulWidget {
  static const routeName = '/on-the-air-tv-series';

  const OnTheAirTvSeriesPage({super.key});

  @override
  State<OnTheAirTvSeriesPage> createState() => _OnTheAirTvSeriesPageState();
}

class _OnTheAirTvSeriesPageState extends State<OnTheAirTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<TvSeriesListCubit>().fetchOnTheAirTvSeries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('On The Air TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocBuilder<TvSeriesListCubit, TvSeriesListState>(
          builder: (context, state) {
            if (state.onTheAirState == RequestState.Loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.onTheAirState == RequestState.Loaded) {
              return ListView.builder(
                itemCount: state.onTheAirTvSeries.length,
                itemBuilder: (context, index) {
                  final tv = state.onTheAirTvSeries[index];
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

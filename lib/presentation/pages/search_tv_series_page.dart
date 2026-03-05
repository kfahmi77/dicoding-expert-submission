import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/tv_series_search/tv_series_search_cubit.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchTvSeriesPage extends StatelessWidget {
  static const routeName = '/search-tv-series';

  const SearchTvSeriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              onSubmitted: (query) {
                context.read<TvSeriesSearchCubit>().fetchTvSeriesSearch(query);
              },
              decoration: const InputDecoration(
                hintText: 'Search title',
                hintStyle: TextStyle(color: Colors.white70),
                prefixIcon: Icon(Icons.search, color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2),
                ),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 16),
            Text('Search Result', style: kHeading6),
            BlocBuilder<TvSeriesSearchCubit, TvSeriesSearchState>(
              builder: (context, state) {
                if (state.state == RequestState.Loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.state == RequestState.Loaded) {
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: state.searchResult.length,
                      itemBuilder: (context, index) {
                        final tvSeries = state.searchResult[index];
                        return TvSeriesCard(tvSeries);
                      },
                    ),
                  );
                }
                return const Expanded(child: SizedBox());
              },
            ),
          ],
        ),
      ),
    );
  }
}

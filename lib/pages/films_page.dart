import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_demo/extension/capitalization.dart';
import 'package:riverpod_demo/riverpod/riverpod.dart';

import '../model/films.dart';
import '../widgets/film_list.dart';

final filmTypeStatusProvider = StateProvider<FilmType>((ref) => FilmType.all);

enum FilmType { all, star, unstar }

class FilmsPage extends ConsumerWidget {
  const FilmsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = ref.watch(themeProvider) == ThemeData.light();
    List<AlwaysAliveProviderBase<Iterable<Films>>> listProvider = [
      filmsProvider,
      favoriteFilmsProvider,
      unFavoriteFilmsProvider,
    ];
    return DefaultTabController(
      length: FilmType.values.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Films Riverpod'),
          centerTitle: true,
          bottom: TabBar(
            onTap: (value) {
              ref.read(filmTypeStatusProvider.notifier).state =
                  FilmType.values[value];
            },
            indicatorWeight: 4,
            labelColor: theme ? Colors.black : Colors.white,
            labelStyle: Theme.of(context).textTheme.titleMedium,
            tabs: FilmType.values
                .map(
                  (type) => Tab(
                    text: type.toString().split('.').last.capitalize(),
                  ),
                )
                .toList(),
          ),
        ),
        body: TabBarView(
          children: listProvider
              .map(
                (provider) => FilmsList(
                  provider: provider,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

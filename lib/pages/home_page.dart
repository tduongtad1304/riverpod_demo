import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_demo/extension/capitalization.dart';

import 'package:riverpod_demo/riverpod/riverpod.dart';

import '../model/films.dart';
import '../widgets/film_list.dart';

final filmTypeStatusProvider = StateProvider<FilmType>((ref) => FilmType.all);

enum FilmType { all, star, unstar }

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    FilmType index = ref.watch(filmTypeStatusProvider);
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
          actions: [
            IconButton(
              onPressed: () {
                final theme = ref.watch(themeProvider.notifier);
                theme.toggleTheme();
              },
              icon: ref.watch(themeProvider) == ThemeData.light()
                  ? const Icon(Icons.sunny)
                  : const Icon(Icons.nightlight_round),
            ),
          ],
          bottom: TabBar(
            onTap: (value) {
              index = ref.read(filmTypeStatusProvider.notifier).state =
                  FilmType.values[value];
              // if (index == FilmType.all) {
              //  loadFilmProvider = ref.read(loadFilmsProvider.future).then(
              //       (value) => ref.read(filmsProvider.notifier).state = value);
              // }
            },
            indicatorWeight: 4,
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
        body: ref.watch(filmsProvider).isNotEmpty
            ? TabBarView(
                children: listProvider
                    .map(
                      (provider) => FilmsList(
                        provider: provider,
                      ),
                    )
                    .toList(),
              )
            : Center(
                child: Text(
                  index == FilmType.all
                      ? 'No Films.\nClick the button below to add a film.'
                      : index == FilmType.star
                          ? 'No Films are marked star.'
                          : 'No Films are marked unstar.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 17),
                  textAlign: TextAlign.center,
                ),
              ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              tooltip: 'Refresh',
              onPressed: () => ref.read(filmsProvider.notifier).loadFilms(),
              child: const Icon(Icons.refresh),
            ),
            const SizedBox(width: 10),
            FloatingActionButton(
              tooltip: 'Add Film',
              onPressed: () => showFilmDialog(context, ref, false),
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}

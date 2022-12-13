import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_demo/extension/capitalization.dart';
import 'package:uuid/uuid.dart';

import 'package:riverpod_demo/riverpod/riverpod.dart';

import '../model.dart/films.dart';

enum FilmType { favorite, all }

final favoriteStatusProvider = StateProvider<FilmType>((ref) => FilmType.all);

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
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
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            const FilterWidget(),
            Consumer(
              builder: (context, ref, child) {
                final filter = ref.watch(favoriteStatusProvider);
                switch (filter) {
                  case FilmType.favorite:
                    return FilmsList(
                      provider: favoriteFilmsProvider,
                    );
                  case FilmType.all:
                    return FilmsList(
                      provider: filmsProvider,
                    );
                }
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Film',
        onPressed: () => _showFilmDialog(context, ref, false),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class FilterWidget extends ConsumerWidget {
  const FilterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DropdownButton(
      value: ref.watch(favoriteStatusProvider),
      items: FilmType.values
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e.toString().split('.').last.capitalize()),
            ),
          )
          .toList(),
      onChanged: (value) {
        ref.read(favoriteStatusProvider.notifier).state = value as FilmType;
      },
    );
  }
}

class FilmsList extends ConsumerWidget {
  final AlwaysAliveProviderBase<Iterable<Films>> provider;
  const FilmsList({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final films = ref.watch(provider);
    return Expanded(
      child: ListView.separated(
          padding: const EdgeInsets.only(top: 10),
          itemBuilder: (context, index) {
            final film = films.elementAt(index);
            final isExist =
                ref.watch(filmsProvider.notifier).isFilmExisted(film.id);
            return GestureDetector(
              onTap: () => _showFilmDialog(context, ref, isExist, index),
              child: ListTile(
                title: Text(film.title),
                subtitle: Text(
                    '${film.description} - ${film.isFavorite == true ? 'Favorite' : 'Not Favorite'}'),
                trailing: IconButton(
                  icon: Icon(
                    film.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: film.isFavorite
                        ? const Color.fromARGB(255, 231, 7, 93)
                        : Colors.grey,
                  ),
                  onPressed: () {
                    ref.read(filmsProvider.notifier).toggleFavorite(film.id);
                  },
                ),
              ),
            );
          },
          separatorBuilder: separatorBuilder,
          itemCount: films.length),
    );
  }

  Widget separatorBuilder(BuildContext context, int index) {
    return const SizedBox(height: 10);
  }
}

Future<Films?> _showFilmDialog(
    BuildContext context, WidgetRef ref, bool isExisted,
    [int? index]) {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController(
      text: index != null ? ref.watch(filmsProvider)[index].title : '');
  final descriptionController = TextEditingController(
      text: index != null ? ref.watch(filmsProvider)[index].description : '');
  return showDialog<Films>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: !isExisted ? const Text('Add Film') : const Text('Edit Film'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                onChanged: (value) {
                  TextSelection previousSelection = titleController.selection;
                  titleController.text = value;
                  titleController.selection = previousSelection;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                onChanged: (value) {
                  TextSelection previousSelection =
                      descriptionController.selection;
                  descriptionController.text = value;
                  descriptionController.selection = previousSelection;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final film = Films(
                  id: isExisted && index != null
                      ? ref.watch(filmsProvider)[index].id
                      : const Uuid().v4(),
                  title: titleController.text,
                  description: descriptionController.text,
                  isFavorite: false,
                );
                log('$film');
                !isExisted
                    ? ref.read(filmsProvider.notifier).addFilm(film)
                    : ref.read(filmsProvider.notifier).updateFilm(film);
                Navigator.of(context).pop();
              }
            },
            child: !isExisted ? const Text('Add') : const Text('Update'),
          ),
        ],
      );
    },
  );
}

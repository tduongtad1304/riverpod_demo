import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_demo/widgets/search_bar.dart';
import 'package:uuid/uuid.dart';

import '../model/films.dart';
import '../riverpod/riverpod.dart';

class FilmsList extends ConsumerWidget {
  final dynamic provider;
  const FilmsList({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (provider.runtimeType != FutureProvider<List<Films>>) {
      final films = ref.watch(provider as ProviderListenable<Iterable<Films>>);
      return Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: [
            provider == filmsProvider
                ? SearchBar(
                    onSearch: (value) {
                      ref
                          .refresh(filmsProvider.notifier)
                          .filterSearchResults(value);
                    },
                  )
                : const SizedBox.shrink(),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 5),
                itemBuilder: (context, index) {
                  final film = films.elementAt(index);
                  final isExist =
                      ref.watch(filmsProvider.notifier).isFilmExisted(film.id);
                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) =>
                        ref.read(filmsProvider.notifier).removeFilm(film.id),
                    confirmDismiss: (direction) {
                      return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Delete Film'),
                            content: const Text(
                                'Are you sure you want to delete this film?'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('No'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text('Yes'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    background: Container(
                      color: Colors.red,
                      child: const Align(
                        child: Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    secondaryBackground: Container(
                      color: Colors.amber,
                      child: const Align(
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(
                            Icons.star,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () => showFilmDialog(context, ref, isExist, index),
                      child: ListTile(
                        title: Text(film.title),
                        subtitle: Text(film.description),
                        trailing: IconButton(
                          icon: Icon(
                            film.isFavorite ? Icons.star : Icons.star_border,
                            color: film.isFavorite ? Colors.amber : Colors.grey,
                            size: 30,
                          ),
                          onPressed: () {
                            ref
                                .read(filmsProvider.notifier)
                                .toggleFavorite(film.id);
                          },
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: separatorBuilder,
                itemCount: films.length,
              ),
            ),
          ],
        ),
      );
    } else {
      final films = ref.watch((provider as FutureProvider<List<Films>>));
      return films.when(
        skipLoadingOnRefresh: films.asData?.value.isNotEmpty ?? false,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (dynamic error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(error, style: Theme.of(context).textTheme.bodyLarge),
              TextButton(
                onPressed: () => ref.refresh(remoteFilmsProvider.future),
                child: const Text('Try again'),
              )
            ],
          ),
        ),
        data: (value) => ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.only(left: 15),
          itemBuilder: (context, index) {
            final film = value.elementAt(index);
            return ListTile(
              title: Text(film.title),
              subtitle: Text(film.description),
              trailing: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: IconButton(
                  icon: Icon(
                    film.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: film.isFavorite
                        ? const Color.fromARGB(255, 250, 3, 209)
                        : Colors.grey,
                    size: 30,
                  ),
                  onPressed: () {
                    ref.read(
                      updateFilmsProvider(
                        film.copyWith(
                            id: film.id, isFavorite: !film.isFavorite),
                      ),
                    );
                  },
                ),
              ),
            );
          },
          separatorBuilder: separatorBuilder,
          itemCount: value.length,
        ),
      );
    }
  }

  Widget separatorBuilder(BuildContext context, int index) {
    return const SizedBox(height: 10);
  }
}

Future<Films?> showFilmDialog(
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

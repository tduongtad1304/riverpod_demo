import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model.dart/films.dart';

class FilmsNotifier extends StateNotifier<List<Films>> {
  FilmsNotifier() : super(Films.listFilms);

  void toggleFavorite(String id) {
    state = state.map((film) {
      if (film.id == id) {
        return film.copyWith(isFavorite: !film.isFavorite, id: film.id);
      }
      return film;
    }).toList();
  }

  void addFilm(Films film) {
    state = [...state, film];
  }

  void removeFilm(String id) {
    state = state.where((film) => film.id != id).toList();
  }

  void updateFilm(Films film) {
    state = state.map((f) {
      if (f.id == film.id) {
        return f.copyWith(
            id: film.id, title: film.title, description: film.description);
      }
      return f;
    }).toList();
  }

  bool isFilmExisted(String id) {
    return state.any((film) => film.id == id);
  }
}

final filmsProvider = StateNotifierProvider<FilmsNotifier, List<Films>>((ref) {
  return FilmsNotifier();
});

final favoriteFilmsProvider = Provider<Iterable<Films>>(
    (ref) => ref.watch(filmsProvider).where((film) => film.isFavorite));
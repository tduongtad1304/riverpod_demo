import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_demo/extension/capitalization.dart';
import 'package:riverpod_demo/services/films_services.dart';

import '../model/films.dart';

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

  void filterSearchResults(String query) {
    List<Films> dummySearchList = [];
    dummySearchList.addAll(state);
    if (query.isNotEmpty) {
      List<Films> dummyListData = [];
      for (var item in dummySearchList) {
        if (item.title.contains(query) ||
            item.description.contains(query) ||
            item.title.contains(query.capitalize()) ||
            item.description.capitalize().contains(query.capitalize())) {
          dummyListData.add(item);
        }
      }
      state = dummyListData;
    } else {
      state = state;
    }
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

final unFavoriteFilmsProvider = Provider<Iterable<Films>>(
    (ref) => ref.watch(filmsProvider).where((film) => !film.isFavorite));

final remoteFilmsProvider = FutureProvider((ref) {
  return FilmsServices.getFilms();
});

final updateFilmsProvider =
    FutureProvider.family<dynamic, Films>((ref, Films film) {
  return FilmsServices.updateFilms(film)
      .whenComplete(() => ref.refresh(remoteFilmsProvider));
});

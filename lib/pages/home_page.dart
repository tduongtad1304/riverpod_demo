import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_demo/pages/films_page.dart';
import 'package:riverpod_demo/pages/settings_page.dart';

import 'package:riverpod_demo/riverpod/riverpod.dart';

import '../widgets/film_list.dart';
import 'extra_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pages = [
      const FilmsPage(),
      const ExtraPage(),
      const SettingsPage(),
    ];
    final index = ref.watch(bottomNavigationBarProvider);
    return Scaffold(
      body: pages[index],
      floatingActionButton: index != 1 && index != 2
          ? FloatingActionButton(
              tooltip: 'Add Film',
              onPressed: () => showFilmDialog(context, ref, false),
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(3, 0, 0, 0),
        onTap: (value) => ref
            .read(bottomNavigationBarProvider.notifier)
            .setActiveIndex(value),
        currentIndex: index,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Movies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.extension_rounded),
            label: 'Extra',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

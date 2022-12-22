import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_demo/riverpod/films_provider.dart';
import 'package:riverpod_demo/widgets/film_list.dart';

class ExtraPage extends ConsumerWidget {
  const ExtraPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () => ref.refresh(remoteFilmsProvider.future),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Extra Page'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: FilmsList(
            provider: remoteFilmsProvider,
          ),
        ),
      ),
    );
  }
}

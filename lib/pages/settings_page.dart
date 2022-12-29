import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_demo/riverpod/riverpod.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            Text('Theme Mode', style: Theme.of(context).textTheme.titleMedium),
            const Spacer(),
            const Text('Light'),
            const SizedBox(width: 3),
            Consumer(
              builder: (context, ref, __) {
                final theme = ref.watch(themeProvider) == ThemeData.dark();
                return CupertinoSwitch(
                  value: theme,
                  onChanged: (value) =>
                      ref.read(themeProvider.notifier).toggleTheme(value),
                );
              },
            ),
            const SizedBox(width: 3),
            const Text('Dark')
          ],
        ),
      ),
    );
  }
}

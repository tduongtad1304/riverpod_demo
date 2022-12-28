import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'app_observer.dart';

void main() {
  runApp(
    ProviderScope(
      observers: [AppObserver()],
      child: const MyApp(),
    ),
  );
}

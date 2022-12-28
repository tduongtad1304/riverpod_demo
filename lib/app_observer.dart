import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppObserver extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    log('didUpdateProvider → ${provider.name ?? provider.runtimeType},  "newValue": "$newValue"');
  }

  @override
  void didDisposeProvider(ProviderBase provider, ProviderContainer container) {
    log('didDisposeProvider → ${provider.name ?? provider.runtimeType}');
  }

  @override
  void didAddProvider(
      ProviderBase provider, Object? value, ProviderContainer container) {
    log('didAddProvider → ${provider.name ?? provider.runtimeType}');
  }
}

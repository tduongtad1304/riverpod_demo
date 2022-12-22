import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomNavigationBarProvider extends StateNotifier<int> {
  BottomNavigationBarProvider() : super(0);

  void setActiveIndex(int index) {
    state = index;
  }
}

final bottomNavigationBarProvider =
    StateNotifierProvider<BottomNavigationBarProvider, int>(
        (ref) => BottomNavigationBarProvider());

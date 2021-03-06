import 'dart:async';

import 'package:flutter/material.dart';

class NavbarNotifier extends ChangeNotifier {
  static final NavbarNotifier _singleton = NavbarNotifier._internal();

  factory NavbarNotifier() {
    return _singleton;
  }

  NavbarNotifier._internal();

  static int _index = 0;

  static int get currentIndex => _index;

  static bool _hideBottomNavBar = false;

  static List<GlobalKey<NavigatorState>> _keys = [];

  static void setKeys(List<GlobalKey<NavigatorState>> value) {
    _keys = value;
  }

  static List<GlobalKey<NavigatorState>> get keys => _keys;

  static set index(int x) {
    _index = x;
    _singleton.notify();
  }

  static bool get isNavbarHidden => _hideBottomNavBar;

  static set hideBottomNavBar(bool x) {
    _hideBottomNavBar = x;
    _singleton.notify();
  }

  // pop routes from the nested navigator stack and not the main stack
  // this is done based on the currentIndex of the bottom navbar
  // if the backButton is pressed on the initial route the app will be terminated
  static FutureOr<bool> onBackButtonPressed() async {
    bool exitingApp = true;
    NavigatorState? currentState;
    for (int i = 0; i < _keys.length; i++) {
      if (_index == i) {
        currentState = _keys[i].currentState;
      }
    }
    if (currentState != null && currentState.canPop()) {
      currentState.pop();
      exitingApp = false;
    }
    if (exitingApp) {
      return true;
    } else {
      return false;
    }
  }

  // pops all routes except first, if there are more than 1 route in each navigator stack
  static void popAllRoutes(int index) {
    NavigatorState? currentState;
    for (int i = 0; i < _keys.length; i++) {
      if (_index == i) {
        currentState = _keys[i].currentState;
      }
    }
    if (currentState != null && currentState.canPop()) {
      currentState.popUntil((route) => route.isFirst);
    }
  }

  void notify() {
    notifyListeners();
  }
}

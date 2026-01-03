import 'package:flutter/cupertino.dart';

class RouterState extends ChangeNotifier {
  int _currentIndex = 2;
  final PageController _pageController = PageController();
  PageController get pageController => _pageController;
  int get currentIndex => _currentIndex;
  void changeIndex(int index) {
    _currentIndex = index;
    _pageController.jumpToPage(index);
    notifyListeners();
  }
}
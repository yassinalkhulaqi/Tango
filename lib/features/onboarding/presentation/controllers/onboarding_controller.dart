import 'package:flutter/material.dart';

class OnboardingController extends ChangeNotifier {
  late final PageController _pageController;
  int _currentPage = 0;
  static const int _totalPages = 3;

  OnboardingController() : _pageController = PageController();

  PageController get pageController => _pageController;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  bool get isFirstPage => _currentPage == 0;
  bool get isLastPage => _currentPage == _totalPages - 1;

  void onPageChanged(int index) {
    if (_currentPage != index) {
      _currentPage = index;
      notifyListeners();
    }
  }

  void nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void skipToEnd() {
    _pageController.animateToPage(
      _totalPages - 1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void onComplete(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/auth');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

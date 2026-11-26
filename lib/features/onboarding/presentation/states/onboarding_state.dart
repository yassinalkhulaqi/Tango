import 'package:flutter/material.dart';

class OnboardingState {
  final int currentPage;
  final int totalPages;
  final AnimationController animationController;

  const OnboardingState({
    required this.currentPage,
    required this.totalPages,
    required this.animationController,
  });

  bool get isFirstPage => currentPage == 0;
  bool get isLastPage => currentPage == totalPages - 1;
  double get progress => (currentPage + 1) / totalPages;

  OnboardingState copyWith({int? currentPage}) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages,
      animationController: animationController,
    );
  }
}

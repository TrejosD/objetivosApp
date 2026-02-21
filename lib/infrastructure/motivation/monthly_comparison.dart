class MonthlyComparison {
  final int currentProgress;
  final int previousProgress;
  final int difference;

  MonthlyComparison({
    required this.currentProgress,
    required this.previousProgress,
  }) : difference = currentProgress - previousProgress;

  bool get isBetter => difference > 0;
  bool get isWorse => difference < 0;
  bool get isSame => difference == 0;

  static MonthlyComparison none() {
    return MonthlyComparison(currentProgress: 0, previousProgress: 0);
  }
}

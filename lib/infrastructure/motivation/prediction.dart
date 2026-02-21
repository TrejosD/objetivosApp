class Prediction {
  final bool willComplete;
  final double expectedProgress;
  final int daysRemaining;
  final double requiredDaily;

  Prediction({
    required this.willComplete,
    required this.expectedProgress,
    required this.daysRemaining,
    required this.requiredDaily,
  });
}

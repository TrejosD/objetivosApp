enum MomentumType { strong, normal, risk }

class Momentum {
  final MomentumType type;
  final int requiredStreak;
  final double dailyRequired;
  final double currentAverage;
  final int daysRemaining;

  Momentum({
    required this.type,
    required this.requiredStreak,
    required this.dailyRequired,
    required this.currentAverage,
    required this.daysRemaining,
  });
}

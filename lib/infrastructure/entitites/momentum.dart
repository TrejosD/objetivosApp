enum MomentumType { strong, normal, risk }

// clase momentum nos permite cambiar el tipo de mensajes motivaciones que mostramos
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

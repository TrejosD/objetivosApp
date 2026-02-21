enum MotivationType { positive, warning, risk, celebration }

class MotivationResult {
  final String message;
  final MotivationType type;

  MotivationResult({required this.message, required this.type});
}

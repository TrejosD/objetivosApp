enum MotivationType { positive, warning, risk, celebration }

// clase permite cambiar el tipo de mensaje motivacional de acuerdo al momentum
class MotivationResult {
  final String message;
  final MotivationType type;

  MotivationResult({required this.message, required this.type});
}

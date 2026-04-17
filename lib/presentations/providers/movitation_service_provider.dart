import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:objetivos/infrastructure/motivation/motivation_service.dart';
import 'package:objetivos/presentations/providers/goals_repository_provider.dart';

// este provider provee el servicio que tenermina los mensajes motivacionales
final motivationServiceProvider = Provider<MotivationService>((ref) {
  final repo = ref.read(goalsRepositoryProvider);
  return MotivationService(repo);
});

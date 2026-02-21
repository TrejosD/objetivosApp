import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:objetivos/infrastructure/motivation/motivation_service.dart';
import 'package:objetivos/presentations/providers/goals_repository_provider.dart';

final motivationServiceProvider = Provider<MotivationService>((ref) {
  final repo = ref.read(goalsRepositoryProvider);
  return MotivationService(repo);
});

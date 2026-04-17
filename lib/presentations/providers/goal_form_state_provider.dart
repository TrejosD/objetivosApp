import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:objetivos/data/entities/goal.dart';
import 'package:objetivos/domain/create_initial_montly_goal.dart';
import 'package:objetivos/presentations/providers/goals_repository_provider.dart';

final goalFormStateProvider =
    StateNotifierProvider.autoDispose<GoalFormNotifier, GoalFormState>((ref) {
      return GoalFormNotifier(ref);
    });

class GoalFormNotifier extends StateNotifier<GoalFormState> {
  final Ref ref;
  GoalFormNotifier(this.ref) : super(const GoalFormState());

  void init(Goal? goal) {
    if (goal != null) {
      state = state.copyWith(name: goal.name, target: goal.target.toString());
    }
  }

  void onNameChanged(String value) {
    String? error;

    if (state.hasSumitted) {
      if (value.trim().isEmpty) {
        error = 'mandatory-name-error'.tr();
      }
    }
    state = state.copyWith(name: value, nameError: error);
  }

  void onTargetChanged(String value) {
    String? error;

    if (state.hasSumitted) {
      if (int.tryParse(value) == null) {
        error = 'goal-needs-value-number-error'.tr();
      } else if (value.isEmpty) {
        error = 'empty-field-error'.tr();
      } else if (int.parse(value) <= 0) {
        error = 'goal-should-more-than-cero-error'.tr();
      }
    }
    state = state.copyWith(target: value, targetError: error);
  }

  void validateAll() {
    String? nameError;
    String? targetError;

    if (state.name.trim().isEmpty) {
      nameError = 'empty-field-error'.tr();
    }
    if (state.target.isEmpty) {
      targetError = 'empty-field-error'.tr();
    } else if (int.tryParse(state.target) == null) {
      targetError = 'goal-needs-value-number-error'.tr();
    } else if (int.parse(state.target) <= 0) {
      targetError = 'goal-should-more-than-cero-error'.tr();
    }

    state = state.copyWith(nameError: nameError, targetError: targetError);
  }

  Future<bool> submitForm(Goal? goal) async {
    state = state.copyWith(hasSumitted: true);
    validateAll();

    if (!state.isValid) return false;
    state = state.copyWith(isLoading: true);
    final repo = ref.read(goalsRepositoryProvider);
    final name = state.name.trim();
    final target = int.parse(state.target);

    if (goal == null) {
      final newGoal = await repo.createGoal(name, target);
      await createInitialMontlyGoal(newGoal);
    } else {
      await repo.updateGoal(goal, name, target);
    }

    state = state.copyWith(isLoading: false);
    return true;
  }
}

class GoalFormState {
  final String name;
  final String? nameError;
  final String target;
  final String? targetError;
  final bool isLoading;
  final bool hasSumitted;

  const GoalFormState({
    this.name = '',
    this.nameError,
    this.target = '',
    this.targetError,
    this.isLoading = false,
    this.hasSumitted = false,
  });

  bool get isValid {
    return nameError == null &&
        targetError == null &&
        name.trim().isNotEmpty &&
        int.tryParse(target) != null &&
        int.parse(target) > 0;
  }

  GoalFormState copyWith({
    String? name,
    String? nameError,
    String? target,
    String? targetError,
    bool? isLoading,
    bool? hasSumitted,
  }) {
    return GoalFormState(
      name: name ?? this.name,
      nameError: nameError,
      target: target ?? this.target,
      targetError: targetError,
      isLoading: isLoading ?? this.isLoading,
      hasSumitted: hasSumitted ?? this.hasSumitted,
    );
  }
}

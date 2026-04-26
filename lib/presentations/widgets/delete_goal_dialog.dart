// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:objetivos/data/entities/goal.dart';
import 'package:objetivos/presentations/providers/goal_form_state_provider.dart';
import 'package:objetivos/presentations/providers/goals_repository_provider.dart';

// este dialog contiene un form para crear un nuevo objetivo de acuerdo al nombre y la meta que desee el usuario
class DeleteGoalDialog extends ConsumerStatefulWidget {
  final Goal goal;
  const DeleteGoalDialog({super.key, required this.goal});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateGoalDialogState();
}

class _CreateGoalDialogState extends ConsumerState<DeleteGoalDialog> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(goalFormStateProvider.notifier).init(widget.goal);
    });
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.read(goalsRepositoryProvider);

    return AlertDialog(
      title: Text('Desea eliminar la meta'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('"${widget.goal.name}"', style: TextStyle(fontSize: 22)),
          Text('Se eliminara todo el historial'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('dialog-button-cancel').tr(),
        ),
        ElevatedButton(
          onPressed: () async {
            await repo.deleteGoal(widget.goal);
            if (mounted) Navigator.pop(context);
          },
          child: Text('dialog-button-accept'.tr()),
        ),
      ],
    );
  }
}

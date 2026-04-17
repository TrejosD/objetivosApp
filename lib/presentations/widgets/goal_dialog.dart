// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:objetivos/data/entities/goal.dart';
import 'package:objetivos/presentations/providers/goal_form_state_provider.dart';

class GoalDialog extends ConsumerStatefulWidget {
  final Goal? goal;
  const GoalDialog({super.key, this.goal});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateGoalDialogState();
}

class _CreateGoalDialogState extends ConsumerState<GoalDialog> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(goalFormStateProvider.notifier).init(widget.goal);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(goalFormStateProvider);
    final notifier = ref.read(goalFormStateProvider.notifier);

    return AlertDialog(
      title: Text(widget.goal == null ? 'new-goal'.tr() : 'edit-goal'.tr()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            onChanged: notifier.onNameChanged,
            controller: TextEditingController(text: state.name)
              ..selection = TextSelection.fromPosition(
                TextPosition(offset: state.name.length),
              ),
            decoration: InputDecoration(
              labelText: 'name-label'.tr(),
              errorText: state.nameError,
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            onChanged: notifier.onTargetChanged,
            controller: TextEditingController(text: state.target)
              ..selection = TextSelection.fromPosition(
                TextPosition(offset: state.target.length),
              ),
            decoration: InputDecoration(
              labelText: 'montly-goal-label'.tr(),
              errorText: state.targetError,
            ),
            keyboardType: TextInputType.numberWithOptions(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('dialog-button-cancel').tr(),
        ),
        ElevatedButton(
          onPressed: state.isLoading || (state.hasSumitted && !state.isValid)
              ? null
              : () async {
                  final success = await notifier.submitForm(widget.goal);
                  if (success && mounted) Navigator.pop(context);
                },
          child: state.isLoading
              ? CircularProgressIndicator()
              : Text(
                  widget.goal == null
                      ? 'dialog-button-create'.tr()
                      : 'dialog-button-submit'.tr(),
                ),
        ),
      ],
    );
  }
}

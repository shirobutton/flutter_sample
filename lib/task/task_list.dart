import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sample/task/task_item.dart';
import 'package:flutter_sample/task/task_provider.dart';

class TaskList extends ConsumerWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskListLength = ref.watch(taskListLengtProvider).valueOrNull ?? 0;
    return ListView.builder(
      itemCount: taskListLength,
      itemBuilder: (context, index) {
        return ProviderScope(
          overrides: [indexProvider.overrideWith((_) => index)],
          child: const TaskItem(),
        );
      },
    );
  }
}

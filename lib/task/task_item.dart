import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sample/task/task_provider.dart';

class TaskItem extends ConsumerWidget {
  const TaskItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(indexProvider);
    final task = ref.watch(taskProvider(index)).valueOrNull;
    if (task == null) return const SizedBox.shrink();
    return ListTile(
      title: Text(task.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: task.isCompleted,
            onChanged: (bool? value) {
              final newTask = task.copyWith(isCompleted: !task.isCompleted);
              ref.read(taskListProvider.notifier).change(newTask);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              ref.read(taskListProvider.notifier).delete(task.id);
            },
          ),
        ],
      ),
    );
  }
}

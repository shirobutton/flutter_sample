import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sample/task/task.dart';
import 'package:flutter_sample/task/task_provider.dart';

class AddTask extends ConsumerWidget {
  final TextEditingController controller = TextEditingController();

  AddTask({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: TextField(controller: controller),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            ref
                .read(taskListProvider.notifier)
                .insert(Task(name: controller.text));
            controller.clear();
          },
        ),
      ],
    );
  }
}

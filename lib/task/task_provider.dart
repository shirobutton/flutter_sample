import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sample/db/todo_database.dart';
import 'package:flutter_sample/task/task.dart';

final indexProvider = Provider<int>((_) {
  throw UnimplementedError();
});

final taskListLengtProvider = FutureProvider((ref) =>
    ref.watch(taskListProvider.selectAsync((taskList) => taskList.length)));

final taskProvider = FutureProviderFamily<Task?, int>(
  (ref, index) => ref.watch(taskListProvider.selectAsync((taskList) {
    if (index >= 0 && index < taskList.length) return taskList[index];
    return null;
  })),
);

final taskListProvider =
    AsyncNotifierProvider<TaskListNotifier, List<Task>>(TaskListNotifier.new);

class TaskListNotifier extends AsyncNotifier<List<Task>> {
  @override
  Future<List<Task>> build() => ref.watch(getTasksProvider.future);

  Future<void> insert(Task task) async {
    final insertedTask = await ref.read(insertTaskProvider(task).future);
    await update((prevList) => [...prevList, insertedTask]);
  }

  Future<void> change(Task task) async {
    final id = task.id;
    if (id == null) return;
    await ref.read(updateTaskProvider(task).future);
    await update((taskList) {
      final index = taskList.indexWhere((element) => element.id == task.id);
      taskList[index] = task;
      return taskList;
    });
  }

  Future<void> delete(int? id) async {
    if (id == null) return;
    await ref.read(deleteTaskProvider(id).future);
    await update((taskList) {
      taskList.removeWhere((element) => element.id == id);
      return taskList;
    });
  }
}

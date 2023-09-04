import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sample/db/shared_preferences.dart';
import 'package:flutter_sample/task/task.dart';

final indexProvider = Provider<int>((_) {
  throw UnimplementedError();
});

final taskListProvider =
    NotifierProvider<TaskListNotifier, List<Task>>(TaskListNotifier.new);

class TaskListNotifier extends Notifier<List<Task>> {
  static const taskListKey = "taskListKey";

  @override
  List<Task> build() {
    final stringList =
        ref.watch(sharedPreferencesProvider).getStringList(taskListKey) ?? [];
    return taskListFromJsonStringList(stringList);
  }

  void update(List<Task> Function(List<Task>) updater) {
    state = updater(state);
    ref
        .read(sharedPreferencesProvider)
        .setStringList(taskListKey, taskListToJsonString(state));
  }

  List<Task> taskListFromJsonStringList(List<String> jsonStringList) =>
      jsonStringList.map((string) {
        final json = jsonDecode(string);
        return Task.fromJson(json);
      }).toList();

  List<String> taskListToJsonString(List<Task> taskList) =>
      taskList.map((task) {
        final json = task.toJson();
        return jsonEncode(json);
      }).toList();
}

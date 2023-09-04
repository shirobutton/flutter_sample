import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sample/task/task.dart';

final taskListProvider = StateProvider<List<Task>>((ref) => []);

final indexProvider = Provider<int>((_) {
  throw UnimplementedError();
});

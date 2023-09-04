import 'package:flutter_sample/task/task.dart';
import 'package:path/path.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'todo_database.g.dart';

const _databaseName = 'todo.db';
const _databaseVersion = 1;
const _table = 'tasks';
const _columnId = 'id';
const _columnName = 'name';
const _columnIsCompleted = 'is_completed';

final _todoDatabaseProvider = FutureProvider<Database>(
  (_) async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, _) async {
        await db.execute('''
          CREATE TABLE $_table(
            $_columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $_columnName TEXT,
            $_columnIsCompleted BOOLEAN
          )
        ''');
      },
    );
  },
);

@riverpod
Future<List<Task>> getTasks(GetTasksRef ref) async {
  final database = await ref.read(_todoDatabaseProvider.future);
  final jsonList = await database.query(_table);
  return jsonList.map((json) => Task.fromJson(json)).toList();
}

@riverpod
Future<Task> insertTask(InsertTaskRef ref, Task task) async {
  final database = await ref.read(_todoDatabaseProvider.future);
  final id = await database.insert(
    _table,
    task.toJson(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
  return task.copyWith(id: id);
}

@riverpod
Future<void> updateTask(UpdateTaskRef ref, Task task) async {
  final database = await ref.read(_todoDatabaseProvider.future);
  await database.update(
    _table,
    task.toJson(),
    where: '$_columnId = ?',
    whereArgs: [task.id],
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

@riverpod
Future<void> deleteTask(DeleteTaskRef ref, int id) async {
  final database = await ref.read(_todoDatabaseProvider.future);
  await database.delete(
    _table,
    where: '$_columnId = ?',
    whereArgs: [id],
  );
}

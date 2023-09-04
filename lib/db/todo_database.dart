import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sample/task/task.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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

final getTasksProvider = FutureProvider<List<Task>>((ref) async {
  final database = await ref.read(_todoDatabaseProvider.future);
  final jsonList = await database.query(_table);
  return jsonList.map((json) => Task.fromJson(json)).toList();
});

final insertTaskProvider = FutureProviderFamily<Task, Task>((ref, task) async {
  final database = await ref.read(_todoDatabaseProvider.future);
  final id = await database.insert(
    _table,
    task.toJson(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
  return task.copyWith(id: id);
});

final updateTaskProvider = FutureProviderFamily<void, Task>((ref, task) async {
  final database = await ref.read(_todoDatabaseProvider.future);
  await database.update(
    _table,
    task.toJson(),
    where: '$_columnId = ?',
    whereArgs: [task.id],
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
});

final deleteTaskProvider = FutureProviderFamily<void, int>((ref, id) async {
  final database = await ref.read(_todoDatabaseProvider.future);
  await database.delete(
    _table,
    where: '$_columnId = ?',
    whereArgs: [id],
  );
});

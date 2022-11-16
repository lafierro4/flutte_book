

import 'package:sqflite/sqflite.dart';

import 'TasksModel.dart';

abstract class TasksDBWorker {
  static final TasksDBWorker db = _SqfliteTasksDBWorker._();
  Future<int> create(Task task);
  Future<void> update(Task task);
  Future<void> delete(int id);
  Future<Task> get(int id);
  Future<List<Task>> getAll();
}

class _SqfliteTasksDBWorker extends TasksDBWorker {
  static const String DB_NAME = 'task.db';
  static const String TBL_NAME = 'tasks';
  static const String KEY_ID = 'id';
  static const String KEY_DESCRIPTION = 'description';
  static const String KEY_DUE_DATE = 'dueDate';
  static const String KEY_COMPLETED = 'completed';
  var _tasks = [];
  var _nextId = 1;
  Database _db;
  _SqfliteTasksDBWorker._();
  Future<Database> get database async =>
      _db ??= await _init();

  Future<Database> _init() async {
    return await openDatabase(DB_NAME,
        version: 1,
        onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute(
              "CREATE TABLE IF NOT EXISTS $TBL_NAME ("
                  "$KEY_ID INTEGER PRIMARY KEY,""$KEY_DESCRIPTION TEXT,"
                  "$KEY_DUE_DATE TEXT,"
                  "$KEY_COMPLETED INTEGER"
                  ")"
          );
        }
    );
  }

  @override
  Future<int> create(Task task) async {
    task = _clone(task)
      ..id = _nextId++;
    _tasks.add(task);
    return task.id;
  }

  @override
  Future<void> update(Task task) async {
    var old = await get(task.id);
    if (old != null) {
      old.description = task.description;
      old.dueDate = task.dueDate;
      old.completed = task.completed;
    }
  }

  @override
  Future<void> delete(int id) async {
    _tasks.removeWhere((n) => n.id == id);
  }

  @override
  Future<Task> get(int id) async {
    return _clone(_tasks.firstWhere(
            (n) => n.id == id, orElse: () => null
    ));
  }

  @override
  Future<List<Task>> getAll() async {
    return List.unmodifiable(_tasks);
  }
}

Task _clone(Task task) {
  if (task != null) {
    return Task()
      ..id = task.id
      ..description = task.description
      ..dueDate = task.dueDate
      ..completed = task.completed;
  }
  return null;
}
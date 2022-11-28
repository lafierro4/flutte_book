import 'package:sqflite/sqflite.dart';
import 'DrawingsModel.dart';

abstract class DrawingsDBWorker{
  static final DrawingsDBWorker db = _SqfliteDrawingsDBWorker._();
  Future<int> create(Drawing drawing);
  Future<void> update(Drawing drawing);
  Future<void> delete(int id);
  Future<Drawing> get(int id);
  Future<List<Drawing>> getAll();
}

class _SqfliteDrawingsDBWorker extends DrawingsDBWorker{
  static const String DB_NAME = 'drawings.db';
  static const String TBL_NAME = 'drawings';
  static const String KEY_ID = '_id';
  static const String KEY_TITLE = 'title';
  Database _db;
  _SqfliteDrawingsDBWorker._();

  Future<Database> get database async =>
    _db ??= await _init();


  Future<Database> _init() async{
    return await openDatabase(DB_NAME,
        version: 1, onOpen: (db)
        {},
    onCreate: (Database db, int version) async{
      await db.execute(
      "CREATE TABLE IF NOT EXIST $TBL_NAME  ("
      "$KEY_ID INTEGER PRIMARY KEY,"
      "$KEY_TITLE TEXT,"
      ")"
    );
    });
  }

  @override
  Future<int> create(Drawing drawing) async{
    Database db = await database;
    int id = await db.rawInsert(
      "INSERT INTO $TBL_NAME ($KEY_TITLE,)"
          "VALUES (?,?)",
      [drawing.title]
    );
    return id;
  }

  @override
  Future<void> delete(int id) async{
    Database db = await database;
    await db.delete(TBL_NAME, where: "$KEY_ID = ?", whereArgs: [id]);
  }

  @override
  Future<Drawing> get(int id) async{
    Database db = await database;
    var values = await db.query(TBL_NAME, where: "$KEY_ID = ?", whereArgs: [id]);
    return values.isEmpty ? null : _drawingFromMap(values.first);
  }

  @override
  Future<List<Drawing>> getAll() async{
    Database db = await database;
    var values = await db.query(TBL_NAME);
    return values.isNotEmpty ? values.map((m) => _drawingFromMap(m)).toList() : [];
  }

  @override
  Future<void> update(Drawing drawing) async{
    Database db = await database;
    await db.update(TBL_NAME, _drawingToMap(drawing),
        where: "$KEY_ID = ?", whereArgs: [drawing.id]);
  }

  Drawing _drawingFromMap(Map map) {
    return Drawing()
      ..id = map[KEY_ID]
      ..title = map[KEY_TITLE];
  }
  Map<String, dynamic> _drawingToMap(Drawing drawing) {
    return <String, dynamic>{}
      ..[KEY_ID] = drawing.id
      ..[KEY_TITLE] = drawing.title;
  }



}



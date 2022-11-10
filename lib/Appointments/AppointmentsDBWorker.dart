import 'package:sqflite/sqflite.dart';


class AppointmentsDBWorker {

  static const String DB_NAME = 'appointments.db';
  static const String TBL_NAME = 'appointments';
  static const String KEY_ID = 'id';
  static const String KEY_TITLE = 'title';
  static const String KEY_DESCRIPTION = 'description';
  static const String KEY_DATE = 'date';
  static const String KEY_TIME = 'time';



  Future<Database> _init() async {
    return await openDatabase(DB_NAME,
        version: 1,
        onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute(
              "CREATE TABLE IF NOT EXISTS $TBL_NAME ("
                  "$KEY_ID INTEGER PRIMARY KEY,"
                  "$KEY_TITLE TEXT,"
                  "$KEY_DESCRIPTION TEXT,"
                  "$KEY_DATE TEXT,"
                  "$KEY_TIME TEXT"
                  ")"
          );
        }
    );
  }
}
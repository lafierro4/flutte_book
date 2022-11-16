import 'package:flutte_book/Appointments/AppointmentsModel.dart';
import 'package:sqflite/sqflite.dart';


abstract class AppointmentsDBWorker {
  static final AppointmentsDBWorker db = _SqfliteAppointmentDBWorker._();
  Future<int> create(Appointment appointment);
  Future<void> update(Appointment appointment);
  Future<void> delete(int id);
  Future<Appointment> get(int id);
  Future<List<Appointment>> getAll();
}

class _SqfliteAppointmentDBWorker extends AppointmentsDBWorker{
  static const String DB_NAME = 'appointments.db';
  static const String TBL_NAME = 'appointments';
  static const String KEY_ID = 'id';
  static const String KEY_TITLE = 'title';
  static const String KEY_DESCRIPTION = 'description';
  static const String KEY_DATE = 'date';
  static const String KEY_TIME = 'time';
  Database _db;
  _SqfliteAppointmentDBWorker._();
  Future<Database> get database async =>
      _db ??= await _init();

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

  @override
  Future<int> create(Appointment appointment) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<void> delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Appointment> get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<List<Appointment>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<void> update(Appointment appointment) {
    // TODO: implement update
    throw UnimplementedError();
  }

}


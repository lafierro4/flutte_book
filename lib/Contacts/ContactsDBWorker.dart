import 'package:sqflite/sqflite.dart';
import 'package:flutte_book/Contacts/ContactsModel.dart';

abstract class ContactsDBWorker {
  static final ContactsDBWorker db = _SqfliteContactsDBWorker._();
  Future<int> create(Contact contact);
  Future<void> update(Contact contact);
  Future<void> delete(int id);
  Future<Contact> get(int id);
  Future<List<Contact>> getAll();
}

class _SqfliteContactsDBWorker extends ContactsDBWorker{

  static const String DB_NAME = 'contacts.db';
  static const String TBL_NAME = 'contacts';
  static const String KEY_ID = 'id';
  static const String KEY_NAME = 'name';
  static const String KEY_PHONE = 'phone';
  static const String KEY_EMAIL = 'email';
  static const String KEY_BIRTHDAY = 'birthday';
  Database _db;
  _SqfliteContactsDBWorker._();
  Future<Database> _init() async {
  return await openDatabase(DB_NAME,
  version: 1,
  onOpen: (db) {},
  onCreate: (Database db, int version) async {
  await db.execute(
  "CREATE TABLE IF NOT EXISTS $TBL_NAME ("
  "$KEY_ID INTEGER PRIMARY KEY,"
  "$KEY_NAME TEXT,"
  "$KEY_PHONE TEXT,"
  "$KEY_EMAIL TEXT,"
  "$KEY_BIRTHDAY TEXT"
  ")"
  );
  }
  );
  }

  @override
  Future<int> create(Contact contact) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<void> delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Contact> get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<List<Contact>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<void> update(Contact contact) {
    // TODO: implement update
    throw UnimplementedError();
  }


}
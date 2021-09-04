import 'package:contact_app/Model/ContactModel.dart';
import 'package:path/path.dart' show join;
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;

class DBHelper {
  static Database _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'contactDb.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db
        .execute('CREATE TABLE contact (id INTEGER PRIMARY KEY, fname TEXT, lname TEXT, email TEXT, avatar TEXT)');
  }

  Future<ContactModel> add(ContactModel contactModel) async {
    var dbClient = await db;
    contactModel.id = await dbClient.insert('contact', contactModel.toMap());
    return contactModel;
  }

  Future<List<ContactModel>> getEmployee() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query('contact', columns: ['id', 'fname','lname', 'email', 'avatar']);
    List<ContactModel> contact = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        contact.add(ContactModel.fromMap(maps[i]));
      }
    }
    return contact;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(
      'contact',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> update(ContactModel contactModel) async {
    var dbClient = await db;
    return await dbClient.update(
      'contact',
      contactModel.toMap(),
      where: 'id = ?',
      whereArgs: [contactModel.id],
    );
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
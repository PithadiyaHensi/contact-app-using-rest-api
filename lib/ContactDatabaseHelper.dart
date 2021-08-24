import 'package:contact_app/Model/ContactModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "contactDb.db";
  static final _databaseVersion = 1;

  static final table = 'contactTable';

  static final columnId = 'id';
  static final columnFirstName = 'first_name';
  static final columnLastName = 'last_name';
  static final columnEmail = 'email';
  static final columnAvatar = 'avatar';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $table($columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnFirstName TEXT, $columnLastName TEXT, $columnEmail TEXT, $columnAvatar TEXT)');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(ContactModel item) async {
    Database db = await instance.database;
    return await db.insert(table, {columnFirstName: item.first_name, columnLastName: item.last_name, columnEmail: item.email, columnAvatar: item.avatar});
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }


  // Queries rows based on the argument received
  Future<Map<String, dynamic>> queryRowById(id) async {
    Database db = await instance.database;

    List<Map> maps =
    await db.query(table, where: '$columnId = ?', whereArgs: [id]);
    return maps.isNotEmpty ? maps.first : null;
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
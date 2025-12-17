import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb {
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await intialDb();
    return _database;
  }

  Future<Database?> intialDb() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'ragabdb.db');
    Database mydb = await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
      onUpgrade: _onUpgrade,
    );
    return mydb;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE "notes" (
        "id" INTEGER  NOT NULL PRIMARY KEY AUTOINCREMENT,
        "title" TEXT NOT NULL,
        "note" TEXT NOT NULL,
        "done" INTEGER DEFAULT 0
        
      );
    ''');
    print("database created ==============================");
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) {
    print("onUpgrade called ==============================");
  }

  Future<List<Map>> readData(String sql) async {
    Database? mydb = await database;
    List<Map> response = await mydb!.rawQuery(sql);
    return response;
  }

  Future<int> insertData(String sql) async {
    Database? mydb = await database;
    int response = await mydb!.rawInsert(sql);
    return response;
  }

  Future<int> updateData(String sql) async {
    Database? mydb = await database;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  Future<int> deleteData(String sql) async {
    Database? mydb = await database;
    int response = await mydb!.rawDelete(sql);
    return response;
  }

  Future<void> deleteDatabaseFile() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'ragabdb.db');
    await deleteDatabase(path);
    print("database deleted ==============================");
  }
}

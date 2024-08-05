import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database? _db;

  DatabaseHelper.internal() {
    // Initialize FFI
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    String path = join(await getDatabasesPath(), 'shop.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Item (
        id INTEGER PRIMARY KEY,
        name TEXT,
        quantity INTEGER,
        code TEXT,
        price REAL
      )
    ''');
  }

  Future<int> insertItem(Map<String, dynamic> item) async {
    var dbClient = await db;
    var result = await dbClient.insert("Item", item);
    return result;
  }

  Future<List<Map<String, dynamic>>> getAllItems() async {
    var dbClient = await db;
    var result = await dbClient.query("Item");
    return result;
  }

  Future<Map<String, dynamic>?> getItemByCode(String code) async {
    var dbClient = await db;
    var result = await dbClient.query("Item", where: "code = ?", whereArgs: [code]);
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }
}

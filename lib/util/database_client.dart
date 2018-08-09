import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_to_do_app/model/todo_item.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  String tableName = "todo";
  String columnId = "id";
  String columnItemName = "itemName";
  String columnDataCreated = "dateCreated";

  static Database _db;

  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "todo_db.db");
    var ourDB = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDB;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY, $columnItemName TEXT, $columnDataCreated TEXT)");
    print("Database Created"); // Yaaaaaaaaaaay!
  }

  Future<int> saveItem(ToDoItem item) async {
    var dbClient = await db;
    int res = await dbClient.insert("$tableName", item.toMap());
    return res;
  }

  Future<List> getItems() async {
    var dbClient = await db;
    var result = await dbClient
        .rawQuery("SELECT * FROM $tableName ORDER BY $columnItemName ASC");
    return result.toList();
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite
        .firstIntValue(await dbClient.rawQuery("COUNT (*) FROM $tableName"));
  }

  Future<ToDoItem> getItem(int id) async {
    var dbClient = await db;
    var result = await dbClient
        .rawQuery("SELECT * FROM $tableName WHERE $columnId = $id");
    if (result.length == 0) return null;
    return ToDoItem.fromMap(result.first);
  }

  Future<int> deleteItem(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete("$tableName", where: "$columnId = ?", whereArgs: [id]);
  }

  Future<int> updateItem(ToDoItem item) async{
    var dbClient = await db;
    return await dbClient.update("$tableName", item.toMap() , where: "$columnId = ?" , whereArgs: [item.id]);
  }

  Future close()async {
    var dbClient = await db;
    return await dbClient.close();
  }
}

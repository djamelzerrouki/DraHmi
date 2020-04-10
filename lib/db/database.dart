import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../model/operation_model.dart';
import 'package:sqflite/sql.dart';
import 'package:sqflite/sqlite_api.dart';

class ClientDatabaseProvider{
  ClientDatabaseProvider._();

  static final  ClientDatabaseProvider db = ClientDatabaseProvider._();
  Database _database;

  //para evitar que abra varias conexciones una y otra vez podemos usar algo como esto..
  Future<Database> get database async {
    if(_database != null) return _database;
    _database = await getDatabaseInstanace();
    return _database;
  }

  Future<Database> getDatabaseInstanace() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "operation.db");
     return await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
        await db.execute("CREATE TABLE Operation ("
            "id integer primary key,"
            "name TEXT,"
            "prix REAL,"
            "date TEXT"
            ")");
      },);
  }

 //##################################################################
//####################### Operations ###############################
//##################################################################

  //Query
  //muestra todos los Operations de la base de datos
  Future<List<Operation>> getAllOperations() async {
    final db = await database;
    var response = await db.query("Operation");
    List<Operation> list = response.map((o) => Operation.fromMap(o)).toList();
    return list;
  }


  //Query
  //muestra un solo Operation por el id la base de datos
  Future<Operation> getOperationWithId(int id) async {
    final db = await database;
    var response = await db.query("Operation", where: "id = ?", whereArgs: [id]);
    return response.isNotEmpty ? Operation.fromMap(response.first): null;
  }
  //Insert
  addOperationToDatabase(Operation operation) async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Operation");
    int id = table.first["id"];
    operation.id = id;
    var raw = await db.insert(
      "Operation",
      operation.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;

  }

  //Delete
  //Delete Operation with id
  deleteOperationWithId(int id) async {
    final db = await database;
    return db.delete("Operation", where: "id = ?", whereArgs: [id]);
  }

  //Delete all Operations
  deleteAllOperation() async {
    final db = await database;
    db.delete("Operation");
  }

  //Update
  updateOperation(Operation operation) async {
    final db = await database;
    var response = await db.update("Operation", operation.toMap(),
        where: "id = ?", whereArgs: [operation.id]);
    return response;
  }



  //muestra un solo Operation por el id la base de datos
  Future<Operation> getOperationsWithDate(String date) async {
    final db = await database;
    var response = await db.query("Operation", where: "date = ?", whereArgs: [date]);
    return response.isNotEmpty ? Operation.fromMap(response.first): null;
  }
  //muestra un solo Operation por el id la base de datos
  Future<Operation> groupOperationsByName(String name) async {
    final db = await database;
     var response = await db.query("Operation" , groupBy: "name");
    return response.isNotEmpty ? Operation.fromMap(response.first): null;
  }
}
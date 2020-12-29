import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class Online{
  static Future<Database> db = db_init();
  static Future<Database> db_init() async {
    WidgetsFlutterBinding.ensureInitialized();
    // Open the database and store the reference.
    Future<Database> database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(),'online.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT UNIQUE, pwd INTEGER)",
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
    return database;
  }

  static Future<void> insertUser(String email, String pwd, Future<Database> database) async {
    // Get a reference to the database.
    final Database db = await database;
    var pwd_e = utf8.encode(pwd);
    var pwd_h = sha256.convert(pwd_e).hashCode;
    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same dog is inserted
    // multiple times, it replaces the previous data.
    await db.insert(
      'users', {
      'email': email,
      'pwd': pwd_h,
    },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    List<Map> id = await db.rawQuery("SELECT id FROM users WHERE email = '$email' AND pwd = $pwd_h") ;
    db.execute("CREATE TABLE cows_" + id[0]["id"].toString() + "(id INTEGER PRIMARY KEY, description TEXT)");
  }

  static Future<List<User>> users(Future<Database> database) async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map> maps = await db.query('users');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return User(
        id: maps[i]['id'],
        email: maps[i]['email'],
        pwd: maps[i]['pwd'].toString(),
      );
    });
  }

  static Future<void> deleteUser(int id, Future<Database> database) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      'users',
      // Use a `where` clause to delete a specific dog.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
    await db.execute(
      "DROP TABLE _cows" + id.toString(),
    );
  }

  static Future<List<int>> checkMatch(String email, String pwd, database) async{
    var pwd_e = utf8.encode(pwd);
    var pwd_h = sha256.convert(pwd_e).hashCode;
    // Get a reference to the database.
    final db = await database;
    // Remove the Dog from the database.
    List<Map> result = await db.rawQuery("SELECT id FROM users WHERE email = '$email' AND pwd = $pwd_h");
    List<int> out = new List(2);
    if(result.isNotEmpty){
      out = [1,result[0]["id"]];
    }
    else{
      print("Fail");
      out = [0,0];
    }
    return out;
  }

  static void test(Future<Database> database) async {

    final Database db = await database;
    /*
    var ppwd = utf8.encode("156");
    var pdigest = sha256.convert(ppwd);

    // Insert a dog into the database.
    await insertUser("oli","156",database);
    // Print the list of dogs (only Fido for now).
    print(await users(database));
    print(pdigest.hashCode);
    // Update Fido's age and save it to the database.
    checkMatch("oli", "156",database);
    checkMatch("addazdazdaz", "27274217",database);
*/  Future<List<User>> a = users(database);
    a.then((value) => print(value));
    print(await db.rawQuery('SELECT * FROM sqlite_master ORDER BY name;'));
  }
}


class User {
  final int id;
  final String email;
  final String pwd;

  User({this.id, this.email, this.pwd});

  Map<String, String> toMap() {
    return {
      'user': email,
      'pwd': pwd,
    };
  }
  Map<String, dynamic> toMap_display() {
    return {
      'id': id,
      'user': email,
      'pwd': pwd,
    };
  }
// Implement toString to make it easier to see information about
// each dog when using the print statement.
  @override
  String toString() {
    return 'User{id: $id, user: $email, pwd: $pwd}';
  }
}
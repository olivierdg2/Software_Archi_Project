//Package used for online db connections
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:flutter_app/database/local.dart';

//Class containing connection/delete/add/etc
class Online{
  //property used to get connection
  static Future<Database> db = db_init();

  //get connection
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

  //Insert a User from its email,pwd in a selected database
  static Future<void> insertUser(String email, String pwd, Future<Database> database) async {
    // Get a reference to the database.
    final Database db = await database;
    //Conversion before insertion
    var pwd_e = utf8.encode(pwd);
    var pwd_h = sha256.convert(pwd_e).hashCode;
    await db.insert(
      'users', {
      'email': email,
      'pwd': pwd_h,
    }
    );
    //Get the id of the inserted user
    List<Map> id = await db.rawQuery("SELECT id FROM users WHERE email = '$email' AND pwd = $pwd_h") ;
    //Create a cows_id table to store cows related to this user
    db.execute("CREATE TABLE cows_" + id[0]["id"].toString() + "(id INTEGER PRIMARY KEY, description TEXT)");
  }

  //Return all users
  static Future<List<User>> users(Future<Database> database) async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all the users
    final List<Map> maps = await db.query('users');

    // Convert the List<Map<String, dynamic> into a List<Users>.
    return List.generate(maps.length, (i) {
      return User(
        id: maps[i]['id'],
        email: maps[i]['email'],
        pwd: maps[i]['pwd'].toString(),
      );
    });
  }

  //Delete a User from its id in a selected database
  static Future<void> deleteUser(int id, Future<Database> database) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the User from the database.
    await db.delete(
      'users',
      where: "id = ?",
      whereArgs: [id],
    );
    //Remove related cows_id table
    await db.execute(
      "DROP TABLE _cows" + id.toString(),
    );
  }

  //Check if there is a match in the selected database for an email/pwd pair
  static Future<List<int>> checkMatch(String email, String pwd, database) async{
    // Get a reference to the database.
    final db = await database;
    //Conversion before comparison
    var pwd_e = utf8.encode(pwd);
    var pwd_h = sha256.convert(pwd_e).hashCode;
    //Get the id of the email/pwd pair
    List<Map> result = await db.rawQuery("SELECT id FROM users WHERE email = '$email' AND pwd = $pwd_h");
    //Output = List(worked ?,id)
    List<int> out = new List(2);
    //Case where match is found
    if(result.isNotEmpty){
      out = [1,result[0]["id"]];
    }
    else{
      //debugging
      print("Fail");
      out = [0,null];
    }
    return out;
  }

  //db test
  static void test(Future<Database> database) async {

    // Get a reference to the database.
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
    */

    //print all Users
    Future<List<User>> a = users(database);
    a.then((value) => print(value));
    //print all sqlite information
    print(await db.rawQuery('SELECT * FROM sqlite_master ORDER BY name;'));
  }

  //Return all Cows from a specific cows_id
  static Future<List<Cow>> cows(int user_id,Future<Database> database) async {
    // Get a reference to the database.
    final Database db = await database;
    // Query the table for all the Cows
    final List<Map> maps = await db.query('cows_' + user_id.toString());

    // Convert the List<Map<String, dynamic> into a List<Cows>.
    return List.generate(maps.length, (i) {
      return Cow(
        id: maps[i]['id'],
        description: maps[i]['description'],
      );
    });
  }

  //Pull cows from an online cows_id table to a local cows table
  static Future<void> pullCows(int user_id, Future<Database> local, Future<Database> online) async {
    // Get a reference to the databases.
    final Database loc = await local;
    //Get cows from the online db
    Future<List<Cow>> cows_online = cows(user_id,online);
    //Transfer cows to local db
    cows_online.then((value) => transferCows(value,loc));

  }
  //Used in pullCows
  //Transfer a list of Cows into a selected db
  static Future<void> transferCows(List<Cow> l,Database db) async {
    //Empty before insertion
    await db.rawDelete("DELETE FROM cows");
    //Copy each Cow
    for(var i = 0; i < l.length; i++){
      copyCows(l[i], db);
    }
  }
  //Used in transferCows
  //Insert a Cow in a selected database
  static Future<void> copyCows(Cow cow,database) async {
    await database.insert(
      'cows',
      cow.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

//Represents a User
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
// each User when using the print statement.
  @override
  String toString() {
    return 'User{id: $id, user: $email, pwd: $pwd}';
  }
}

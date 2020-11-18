import 'dart:async';
import 'dart:io';
import 'package:flutter/widgets.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

void main() async {
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();
  // Open the database and store the reference.
  final Future<Database> database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'accounts.db'),
    // When the database is first created, create a table to store dogs.
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE users(id INTEGER PRIMARY KEY, user INTEGER, pwd INTEGER)",
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );

  Future<void> insertUser(User user) async {
    // Get a reference to the database.
    final Database db = await database;

    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same dog is inserted
    // multiple times, it replaces the previous data.
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<User>> users() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map> maps = await db.query('users');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return User(
        id: maps[i]['id'],
        user: maps[i]['user'],
        pwd: maps[i]['pwd'],
      );
    });
  }

  Future<void> updateUser(User user) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Dog.
    await db.update(
      'users',
      user.toMap(),
      // Ensure that the Dog has a matching id.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [user.id],
    );
  }

  Future<void> deleteUser(int id) async {
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
  }

  void checkMatch(String user, pwd) async{
    var user_e = utf8.encode(user);
    var pwd_e = utf8.encode(pwd);
    var user_h = sha256.convert(user_e).hashCode;
    var pwd_h = sha256.convert(pwd_e).hashCode;
    // Get a reference to the database.
    final db = await database;
    // Remove the Dog from the database.
    List<Map> result = await db.rawQuery('SELECT id FROM users WHERE user = $user_h AND pwd = $pwd_h');

    if(result.isNotEmpty){
      print(result);
    }
    else{
      print("Fail");
    }
  }
  var bytes = utf8.encode("oli"); // data being hashed
  var digest = sha256.convert(bytes);
  var ppwd = utf8.encode("156");
  var pdigest = sha256.convert(ppwd);

  var oli = User(
  id: 0,
  user: digest.hashCode,
  pwd: pdigest.hashCode,
  );
  // Insert a dog into the database.
  await insertUser(oli);

  // Print the list of dogs (only Fido for now).
  print(await users());
  print(digest.hashCode);
  print(pdigest.hashCode);
  // Update Fido's age and save it to the database.
  checkMatch("oli", "156");
  checkMatch("addazdazdaz", "27274217");
}
class User {
  final int id;
  final int user;
  final int pwd;

  User({this.id,this.user, this.pwd});

  Map<String, int> toMap() {
    return {
      'id' : id,
      'user': user,
      'pwd': pwd,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'User{id: $id, user: $user, pwd: $pwd}';
  }
}
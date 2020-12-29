import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class Local{
  static Future<Database> db = db_init();
  static Future<Database> db_init() async {
      // Avoid errors caused by flutter upgrade.
      // Importing 'package:flutter/widgets.dart' is required.
      WidgetsFlutterBinding.ensureInitialized();
      // Open the database and store the reference.
      Future<Database> database = openDatabase(
        // Set the path to the database. Note: Using the `join` function from the
        // `path` package is best practice to ensure the path is correctly
        // constructed for each platform.
        join(await getDatabasesPath(),'local.db'),
        onCreate: (db, version) {
          return db.execute(
            "CREATE TABLE cows(id INTEGER PRIMARY KEY, description TEXT)",
          );
        },
        // Set the version. This executes the onCreate function and provides a
        // path to perform database upgrades and downgrades.
        version: 1,
      );
    return database;
  }

  static Future<void> insertCow(Cow cow, Future<Database> database) async {
    // Get a reference to the database.
    final Database db = await database;

    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same dog is inserted
    // multiple times, it replaces the previous data.
    await db.insert(
      'cows',
      cow.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  static Future<List<Cow>> cows(Future<Database> database) async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map> maps = await db.query('cows');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Cow(
        id: maps[i]['id'],
        description: maps[i]['description'],
      );
    });
  }

  static Future<void> updateCow(Cow cow, Future<Database> database) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Dog.
    await db.update(
      'cows',
      cow.toMap(),
      // Ensure that the Dog has a matching id.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [cow.id],
    );
  }

  static Future<void> deleteCow(int id, Future<Database> database) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      'cows',
      // Use a `where` clause to delete a specific dog.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
  static void testCow(Future<Database> database) async {
    final Database db = await database;
    print(await cows(database));
    print(await db.rawQuery('SELECT * FROM sqlite_master ORDER BY name;'));
  }
}

class Cow {
  int id;
  String description;

  Cow({
    this.id,
    this.description
  });

  Map<String,dynamic> toMap() {
    return {
      'id': id,
      'description': description,
    };
  }

// Implement toString to make it easier to see information about
// each dog when using the print statement.
  @override
  String toString() {
    return 'Cow{id: $id, description: $description}';
  }
}
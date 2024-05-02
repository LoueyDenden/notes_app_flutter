import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQLHelper {
  static Future<void> createTables(Database database) async {
    await database.execute("""CREATE TABLE notes(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      title TEXT,
      description TEXT,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
      label TEXT
      )
      """);
  }

  static Future<Database> db() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'notes1.db');
    return openDatabase(path, version: 1,
      onCreate: (Database database, int version) async {
        await createTables(database);
      },

    );
  }

  static Future<int> createNote(String title, String? description, String? label) async {
    final db = await SQLHelper.db();
    final data = {'title': title, 'description': description, 'label': label};
    final id = await db.insert('notes', data,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getNotes() async {
    final db = await SQLHelper.db();
    return db.query('notes', orderBy: "id");

  }

  static Future<List<Map<String, dynamic>>> getNote(int id) async {
    final db = await SQLHelper.db();
    return db.query('notes', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<List<Map<String, dynamic>>> getLabel(String label) async {
    final db = await SQLHelper.db();
    return db.query('notes', where: "label = ?", whereArgs: [label]);
  }

  static Future<int> updateNote(int id, String title, String? description, String? label) async {
    final db = await SQLHelper.db();

    final data = {
      'title': title,
      'description': description,
      'createdAt': DateTime.now().toString(),
      'label': label,
    };

    final result =
    await db.update('notes', data, where: "id = ?", whereArgs: [id]);
    print("${id.toString()}: edited  ${title}");
    return result;
  }

  static Future<void> deleteNote(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("notes", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting a note: $err");
    }
  }
}
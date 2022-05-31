import 'dart:io';

import 'package:crud_operations/contact.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = 'ContactData.db';
  static const _databaseVersion = 1;

  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    return await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    Directory dataDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(dataDirectory.path, _databaseName);
    return await openDatabase(dbPath, version: _databaseVersion,
        onCreate: (db, index) async {
      await db.execute(
          'CREATE TABLE ${Contact.tableName}(${Contact.colId} INTEGER PRIMARY KEY AUTOINCREMENT, ${Contact.colName} TEXT, ${Contact.colNumber} TEXT)');
    });
  }

  Future<int> insertContact(Contact contact) async {
    Database db = await database;
    return await db.insert(Contact.tableName, contact.toMap());
  }

  Future<int> updateContact(Contact contact) async {
    Database db = await database;
    return await db.update(Contact.tableName, contact.toMap(),where: '${Contact.colId}=?',whereArgs: [contact.id]);
  }

  Future<int> deleteContact(int id) async {
    Database db = await database;
    return await db.delete(Contact.tableName,where: '${Contact.colId}=?',whereArgs: [id]);
  }

  Future<List<Contact>> fetchContacts() async {
    Database db = await database;
    List<Map> contacts = await db.query(Contact.tableName);
    return contacts.isEmpty
        ? []
        : contacts
            .map((e) => Contact.fromMap(e as Map<String, dynamic>))
            .toList();
  }
}

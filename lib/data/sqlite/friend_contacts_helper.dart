import 'dart:io';

import 'package:ghost_chat/data/sqlite/database_configs.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FriendContactsHelper {
  static const table = 'friend_contacts';

  static const columnFriendId = 'friendId';
  static const columnFriendName = 'friendName';
  static const columnFriendNumber = 'friendNumber';

  FriendContactsHelper._privateConstructor();
  static final FriendContactsHelper instance =
      FriendContactsHelper._privateConstructor();

  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, databaseName);

      Database database = await openDatabase(path, version: 1, onOpen: (db) {},
          onCreate: (Database db, int version) async {
        await db.execute("CREATE TABLE $table ("
            "$columnFriendId PRIMARY KEY,"
            "$columnFriendName TEXT,"
            "$columnFriendNumber TEXT,"
            ")");
      });
      return database;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<String>> searchFriend({required String searchText}) async {
    try {
      final db = await database;

      List<Map<String, dynamic>> results = await db!.rawQuery(
          "SELECT * FROM $table WHERE $columnFriendName LIKE '%$searchText%' OR  $columnFriendNumber LIKE '%$searchText%'");
      List<String> friendIds = [];

      for (var result in results) {
        String friendId = result["friendId"];
        friendIds.add(friendId);
      }
      return friendIds;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<String>> getAllFriends() async {
    try {
      final db = await database;
      List<Map<String, dynamic>> results =
          await db!.rawQuery("SELECT * FROM $table ORDER BY $columnFriendName");
      List<String> friendIds = [];
      for (var result in results) {
        String friendId = result["friendId"];
        friendIds.add(friendId);
      }
      return friendIds;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> addFriend(
      {required String friendId,
      required String friendName,
      required String friendNumber}) async {
    try {
      final db = await database;

      List<Map<String, dynamic>> results = await db!
          .rawQuery("SELECT * FROM $table WHERE $columnFriendId = $friendId");
      if (results.isEmpty) {
        await db.execute(
            "INSERT INTO $table ($columnFriendId, $columnFriendName, $columnFriendNumber,) VALUES ($friendId, $friendName, $friendNumber,)");
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> getFriend({required String friendId}) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db!
        .rawQuery("SELECT * FROM $table WHERE $columnFriendId = $friendId");
    List<String> friendIds = [];
    for (var result in results) {
      String friendId = result["friendId"];
      friendIds.add(friendId);
    }
    if (results.isNotEmpty) {
      return friendIds[0];
    } else {
      throw "No Contacts found!";
    }
  }
}

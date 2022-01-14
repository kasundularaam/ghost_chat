import 'dart:io';

import 'package:ghost_chat/data/models/decoded_message_model.dart';
import 'package:ghost_chat/data/sqlite/database_configs.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MessageHelper {
  static const table = 'message';

  static const columnMessageId = 'columnMessageId';
  static const columnSenderId = 'columnSenderId';
  static const columnReciverId = 'columnReciverId';
  static const columnSentTimestamp = 'columnSentTimestamp';
  static const columnMessageStatus = 'columnMessageStatus';
  static const columnMessage = 'columnMessage';

  static Database? _database;
  static Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initDatabase();
    return _database;
  }

  static Future<Database> initDatabase() async {
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, databaseName);

      Database database = await openDatabase(path, version: 1, onOpen: (db) {},
          onCreate: (Database db, int version) async {
        await db.execute("CREATE TABLE $table ("
            "$columnMessageId PRIMARY KEY,"
            "$columnSenderId TEXT,"
            "$columnReciverId TEXT,"
            "$columnSentTimestamp TEXT,"
            "$columnMessageStatus TEXT,"
            "$columnMessage TEXT"
            ")");
      });
      return database;
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<void> addMessage(
      {required DecodedMessageModel decodedMessage}) async {
    try {
      final db = await database;
      List<Map<String, dynamic>> results = await db!.query(table,
          where: "$columnMessageId = ?", whereArgs: [decodedMessage.messageId]);
      if (results.isEmpty) {
        await db.rawInsert(
            "INSERT INTO $table ($columnMessageId, $columnSenderId, $columnReciverId, $columnSentTimestamp, $columnMessageStatus, $columnMessage) VALUES(?, ?, ?, ?, ?, ?)",
            [
              decodedMessage.messageId,
              decodedMessage.senderId,
              decodedMessage.reciverId,
              decodedMessage.sentTimestamp,
              decodedMessage.messageStatus,
              decodedMessage.message
            ]);
      }
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<void> updateMessage(
      {required Stream<DecodedMessageModel> messageStream}) async {
    try {
      messageStream.listen((message) async {
        final db = await database;
        await db?.update(table, message.toMap(),
            where: "$columnMessageId = ?", whereArgs: [message.messageId]);
      });
    } catch (e) {
      e.toString();
    }
  }

  static Future<DecodedMessageModel> getMessage(
      {required String messageId}) async {
    try {
      final db = await database;
      List<Map<String, dynamic>> results = await db!
          .query(table, where: "$columnMessageId = ?", whereArgs: [messageId]);
      List<DecodedMessageModel> messages = [];
      for (var result in results) {
        messages.add(DecodedMessageModel(
            messageId: result[columnMessageId],
            senderId: result[columnSenderId],
            reciverId: result[columnReciverId],
            sentTimestamp: result[columnSentTimestamp],
            messageStatus: result[columnMessageStatus],
            message: result[columnMessage]));
      }
      if (messages.isNotEmpty) {
        return messages[0];
      } else {
        throw "No Message found!";
      }
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<bool> checkMessageExist({required String messageId}) async {
    try {
      final db = await database;
      List<Map<String, dynamic>> results = await db!
          .query(table, where: "$columnMessageId = ?", whereArgs: [messageId]);
      List<DecodedMessageModel> messages = [];
      for (var result in results) {
        messages.add(DecodedMessageModel(
            messageId: result[columnMessageId],
            senderId: result[columnSenderId],
            reciverId: result[columnReciverId],
            sentTimestamp: result[columnSentTimestamp],
            messageStatus: result[columnMessageStatus],
            message: result[columnMessage]));
      }
      if (results.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw e.toString();
    }
  }
}

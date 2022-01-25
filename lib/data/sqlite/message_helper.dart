import 'dart:io';

import 'package:ghost_chat/data/models/fi_text_message.dart';
import 'package:ghost_chat/data/models/fi_voice_message.dart';
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

  static Future<void> addVoiceMessage(
      {required FiVoiceMessage fiVoiceMessage}) async {
    try {
      final db = await database;
      List<Map<String, dynamic>> results = await db!.query(table,
          where: "$columnMessageId = ?", whereArgs: [fiVoiceMessage.messageId]);
      if (results.isEmpty) {
        await db.rawInsert(
            "INSERT INTO $table ($columnMessageId, $columnSenderId, $columnReciverId, $columnSentTimestamp, $columnMessageStatus, $columnMessage) VALUES(?, ?, ?, ?, ?, ?)",
            [
              fiVoiceMessage.messageId,
              fiVoiceMessage.senderId,
              fiVoiceMessage.reciverId,
              fiVoiceMessage.sentTimestamp,
              fiVoiceMessage.messageStatus,
              fiVoiceMessage.audioFilePath
            ]);
      }
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<void> addTextMessage(
      {required FiTextMessage fiTextMessage}) async {
    try {
      final db = await database;
      List<Map<String, dynamic>> results = await db!.query(table,
          where: "$columnMessageId = ?", whereArgs: [fiTextMessage.messageId]);
      if (results.isEmpty) {
        await db.rawInsert(
            "INSERT INTO $table ($columnMessageId, $columnSenderId, $columnReciverId, $columnSentTimestamp, $columnMessageStatus, $columnMessage) VALUES(?, ?, ?, ?, ?, ?)",
            [
              fiTextMessage.messageId,
              fiTextMessage.senderId,
              fiTextMessage.reciverId,
              fiTextMessage.sentTimestamp,
              fiTextMessage.messageStatus,
              fiTextMessage.message
            ]);
      }
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<void> updateMessage(
      {required Stream<FiTextMessage> messageStream}) async {
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

  static Future<FiTextMessage> getTextMessage(
      {required String messageId}) async {
    try {
      final db = await database;
      List<Map<String, dynamic>> results = await db!
          .query(table, where: "$columnMessageId = ?", whereArgs: [messageId]);
      List<FiTextMessage> messages = [];
      for (var result in results) {
        messages.add(FiTextMessage(
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

  static Future<FiVoiceMessage> getVoiceMsg({required String messageId}) async {
    try {
      final db = await database;
      List<Map<String, dynamic>> results = await db!
          .query(table, where: "$columnMessageId = ?", whereArgs: [messageId]);
      List<FiVoiceMessage> messages = [];
      for (var result in results) {
        messages.add(
          FiVoiceMessage(
            messageId: result[columnMessageId],
            senderId: result[columnSenderId],
            reciverId: result[columnReciverId],
            sentTimestamp: result[columnSentTimestamp],
            messageStatus: result[columnMessageStatus],
            audioFilePath: result[columnMessage],
          ),
        );
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
      List<FiTextMessage> messages = [];
      for (var result in results) {
        messages.add(FiTextMessage(
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

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
  static const columnReceiverId = 'columnReceiverId';
  static const columnSentTimestamp = 'columnSentTimestamp';
  static const columnMessageStatus = 'columnMessageStatus';
  static const columnMessage = 'columnMessage';
  static const columnDisappearingDuration = 'columnDisappearingDuration';
  static const columnMsgSeenTime = 'columnMsgSeenTime';

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
            "$columnReceiverId TEXT,"
            "$columnSentTimestamp TEXT,"
            "$columnMessageStatus TEXT,"
            "$columnMessage TEXT,"
            "$columnDisappearingDuration TEXT,"
            "$columnMsgSeenTime TEXT"
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
            "INSERT INTO $table ($columnMessageId, $columnSenderId, $columnReceiverId, $columnSentTimestamp, $columnMessageStatus, $columnMessage, $columnDisappearingDuration, $columnMsgSeenTime) VALUES(?, ?, ?, ?, ?, ?, ?, ?)",
            [
              fiVoiceMessage.messageId,
              fiVoiceMessage.senderId,
              fiVoiceMessage.receiverId,
              fiVoiceMessage.sentTimestamp,
              fiVoiceMessage.messageStatus,
              fiVoiceMessage.audioFilePath,
              fiVoiceMessage.disappearingDuration,
              fiVoiceMessage.msgSeenTime
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
            "INSERT INTO $table ($columnMessageId, $columnSenderId, $columnReceiverId, $columnSentTimestamp, $columnMessageStatus, $columnMessage, $columnDisappearingDuration, $columnMsgSeenTime) VALUES(?, ?, ?, ?, ?, ?, ?, ?)",
            [
              fiTextMessage.messageId,
              fiTextMessage.senderId,
              fiTextMessage.receiverId,
              fiTextMessage.sentTimestamp,
              fiTextMessage.messageStatus,
              fiTextMessage.message,
              fiTextMessage.disappearingDuration,
              fiTextMessage.msgSeenTime
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
        messages.add(
          FiTextMessage(
            messageId: result[columnMessageId],
            senderId: result[columnSenderId],
            receiverId: result[columnReceiverId],
            sentTimestamp: result[columnSentTimestamp],
            messageStatus: result[columnMessageStatus],
            message: result[columnMessage],
            disappearingDuration: result[columnDisappearingDuration],
            msgSeenTime: result[columnMsgSeenTime],
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
            receiverId: result[columnReceiverId],
            sentTimestamp: result[columnSentTimestamp],
            messageStatus: result[columnMessageStatus],
            audioFilePath: result[columnMessage],
            disappearingDuration: result[columnDisappearingDuration],
            msgSeenTime: result[columnMsgSeenTime],
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
        messages.add(
          FiTextMessage(
            messageId: result[columnMessageId],
            senderId: result[columnSenderId],
            receiverId: result[columnReceiverId],
            sentTimestamp: result[columnSentTimestamp],
            messageStatus: result[columnMessageStatus],
            message: result[columnMessage],
            disappearingDuration: result[columnDisappearingDuration],
            msgSeenTime: result[columnMsgSeenTime],
          ),
        );
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

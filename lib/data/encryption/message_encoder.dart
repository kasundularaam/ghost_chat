import 'dart:io';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as crypto;
import 'package:flutter/services.dart';
import 'package:ghost_chat/data/encyption/configs.dart';
import 'package:ghost_chat/data/encyption/pad_cryption_key.dart';
import 'package:image/image.dart' as imglib;
import 'package:flutter/material.dart';
import 'package:ghost_chat/data/requests/encode_request.dart';
import 'package:path_provider/path_provider.dart';

int getEncoderCapacity(Uint16List img) {
  return img.length;
}

Uint16List msg2bytes(String msg) {
  return Uint16List.fromList(msg.codeUnits);
}

Future<Uint16List> loadAssetUnit16List(String assetName) async {
  ByteData bytes = await rootBundle.load(assetName);
  Uint16List data = bytes.buffer.asUint16List();
  return data;
}

Future<Uint8List> loadAssetUnit8List(String assetName) async {
  ByteData bytes = await rootBundle.load(assetName);
  Uint8List data = bytes.buffer.asUint8List();
  return data;
}

int getMsgSize(String msg) {
  Uint16List byteMsg = msg2bytes(msg);
  return byteMsg.length * dataLength;
}

int encodeOnePixel(int pixel, int msg) {
  if (msg != 1 && msg != 0) {
    throw FlutterError('msg_encode_bit_more_than_1_bit');
  }
  int lastBitMask = 254;
  int encoded = (pixel & lastBitMask) | msg;
  return encoded;
}

Uint16List padMsg(int capacity, Uint16List msg) {
  Uint16List padded = Uint16List(capacity);
  for (int i = 0; i < msg.length; ++i) {
    padded[i] = msg[i];
  }
  return padded;
}

Uint16List expandMsg(Uint16List msg) {
  Uint16List expanded = Uint16List(msg.length * dataLength);
  for (int i = 0; i < msg.length; ++i) {
    int msgByte = msg[i];
    for (int j = 0; j < dataLength; ++j) {
      int lastBit = msgByte & 1;
      expanded[i * dataLength + (dataLength - j - 1)] = lastBit;
      msgByte = msgByte >> 1;
    }
  }
  return expanded;
}

Future<File> encodeMessageIntoImage(EncodeRequest req) async {
  try {
    Uint16List img = await loadAssetUnit16List("assets/images/original2.png");
    Uint8List img8List = await loadAssetUnit8List("assets/images/original2.png");
    imglib.Image? original = imglib.decodeImage(img8List);
    String msg = req.msg;
    String? token = req.token;
    if (req.shouldEncrypt()) {
      crypto.Key key = crypto.Key.fromUtf8(padCryptionKey(token!));
      crypto.IV iv = crypto.IV.fromLength(16);
      crypto.Encrypter encrypter = crypto.Encrypter(crypto.AES(key));
      crypto.Encrypted encrypted = encrypter.encrypt(msg, iv: iv);
      msg = encrypted.base64;
    }
    Uint16List encodedImg = img;
    if (getEncoderCapacity(img) < getMsgSize(msg)) {
      throw FlutterError('image_capacity_not_enough');
    }
    Uint16List expandedMsg = expandMsg(msg2bytes(msg));

    Uint16List paddedMsg = padMsg(getEncoderCapacity(img), expandedMsg);

    if (paddedMsg.length != getEncoderCapacity(img)) {
      throw FlutterError('msg_container_size_not_match');
    }
    for (int i = 0; i < getEncoderCapacity(img); ++i) {
      encodedImg[i] = encodeOnePixel(img[i], paddedMsg[i]);
    }
    imglib.Image editableImage = imglib.Image.fromBytes(
        original!.width, original.height, encodedImg.toList());

    Uint8List data = Uint8List.fromList(encodedImg);
    MemoryImage image = MemoryImage(data);
    File file = File.fromRawPath(data);
     Directory directory = await getApplicationDocumentsDirectory();
     String path = directory.path;
     print(path);
    await file.copy('$path/image2.png');

    return file;
  } catch (e) {
    throw e.toString();
  }
}

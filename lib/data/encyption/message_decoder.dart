import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as crypto;
import 'package:flutter/services.dart';
import 'package:ghost_chat/data/encyption/configs.dart';
import 'package:ghost_chat/data/encyption/pad_cryption_key.dart';
import 'package:ghost_chat/data/requests/decode_request.dart';

int extractLastBit(int pixel) {
  int lastBit = pixel & 1;
  return lastBit;
}

int assembleBits(Uint16List byte) {
  if (byte.length != dataLength) {
    throw 'byte_incorrect_size';
  }
  int assembled = 0;
  for (int i = 0; i < dataLength; ++i) {
    if (byte[i] != 1 && byte[i] != 0) {
      throw 'bit_not_0_or_1';
    }
    assembled = assembled << 1;
    assembled = assembled | byte[i];
  }
  return assembled;
}

Uint16List bits2bytes(Uint16List bits) {
  if ((bits.length % dataLength) != 0) {
    throw 'bits_contain_incomplete_byte';
  }
  int byteCnt = bits.length ~/ dataLength;
  Uint16List byteMsg = Uint16List(byteCnt);
  for (int i = 0; i < byteCnt; ++i) {
    Uint16List bitsOfByte = Uint16List.fromList(
        bits.getRange(i * dataLength, i * dataLength + dataLength).toList());
    int byte = assembleBits(bitsOfByte);
    byteMsg[i] = byte;
  }
  return byteMsg;
}

Uint16List extractBitsFromImg(Uint16List img) {
  Uint16List extracted = Uint16List(img.length);
  for (int i = 0; i < img.length; i++) {
    extracted[i] = extractLastBit(img[i]);
  }
  return extracted;
}

Uint16List sanitizePaddingZeros(Uint16List msg) {
  int lastNonZeroIdx = msg.length - 1;
  while (msg[lastNonZeroIdx] == 0) {
    --lastNonZeroIdx;
  }
  Uint16List sanitized =
      Uint16List.fromList(msg.getRange(0, lastNonZeroIdx + 1).toList());
  return sanitized;
}

Uint16List padToBytes(Uint16List msg) {
  int padSize = dataLength - msg.length % dataLength;
  Uint16List padded = Uint16List(msg.length + padSize);
  for (int i = 0; i < msg.length; ++i) {
    padded[i] = msg[i];
  }
  for (int i = 0; i < padSize; ++i) {
    padded[msg.length + i] = 0;
  }
  return padded;
}

String bytes2msg(Uint16List bytes) {
  return String.fromCharCodes(bytes);
}

Future<String> decodeMessageFromImage({required DecodeRequest req}) async {
  Uint16List img = (await NetworkAssetBundle(Uri.parse(req.imgToDecode))
          .load(req.imgToDecode))
      .buffer
      .asUint16List();
  Uint16List extracted = extractBitsFromImg(img);
  Uint16List padded = padToBytes(extracted);
  Uint16List byteMsg = bits2bytes(padded);
  Uint16List sanitized = sanitizePaddingZeros(byteMsg);
  String msg = bytes2msg(sanitized);
  String? token = req.token;
  if (req.shouldDecrypt()) {
    crypto.Key key = crypto.Key.fromUtf8(padCryptionKey(token!));
    crypto.IV iv = crypto.IV.fromLength(16);
    crypto.Encrypter encrypter = crypto.Encrypter(crypto.AES(key));
    crypto.Encrypted encryptedMsg = crypto.Encrypted.fromBase64(msg);
    msg = encrypter.decrypt(encryptedMsg, iv: iv);
  }
  return msg;
}

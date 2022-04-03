import 'dart:io';

import 'package:ghost_chat/carcal_steg/dwt_codec.dart';
import 'package:ghost_chat/carcal_steg/hadamard_codec.dart';
import 'package:ghost_chat/carcal_steg/repetition_codecs.dart';
import 'package:image/image.dart' as image_lib;

String handleDecodeRequest(
    {required String imagePath, required int messageLength}) {
  var inputImage = image_lib.decodeImage(File(imagePath).readAsBytesSync())!;
  var repetitions = (inputImage.length * 3) ~/ (messageLength * 256 * 64);
  var coder = DWTStegnanography.withECC(
    inputImage,
    ValuePluralityRepetitionCorrection(
      HadamardErrorCorrection(),
      repetitions,
      (value) {
        return ((value >= 32) && (value <= 126));
      },
    ),
  );
  return coder.decodeMessage(messageLength);
}

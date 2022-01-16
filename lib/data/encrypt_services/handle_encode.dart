import 'dart:io';
import 'package:ghost_chat/carcal_steg/dwt_codec.dart';
import 'package:ghost_chat/carcal_steg/hadamard_codec.dart';
import 'package:ghost_chat/carcal_steg/repetition_codecs.dart';
import 'package:ghost_chat/data/requests/encode_request.dart';
import 'package:image/image.dart' as image_lib;
import 'package:path_provider/path_provider.dart';

Future<String> handleEncodeRequest({required EncodeRequest request}) async {
  var inputImage =
      image_lib.decodeImage(File(request.imagePath).readAsBytesSync())!;
  if (inputImage.width % 8 != 0 || inputImage.height % 8 != 0) {
    var shrunkWidth = inputImage.width - inputImage.width % 8;
    var shrunkHeight = inputImage.height - inputImage.height % 8;
    inputImage = image_lib.copyResize(inputImage,
        width: shrunkWidth, height: shrunkHeight);
  }
  var messageLength = request.message.length;
  var repetitions = (inputImage.length * 3) ~/ (messageLength * 256 * 64);
  var coder = DWTStegnanography.withECC(
    inputImage,
    ValuePluralityRepetitionCorrection(
      HadamardErrorCorrection(),
      repetitions,
    ),
  );

  Directory dir = await getApplicationSupportDirectory();
  String filePath =
      "${dir.path}/send/${request.conversatioId}/${request.messageId}.png";

  image_lib.Image newImage = coder.encodeMessage(request.message);
  try {
    File file = await File(filePath).create(recursive: true);
    await file.writeAsBytes(image_lib.encodePng(newImage));
    return file.path;
  } catch (e) {
    throw e.toString();
  }
}

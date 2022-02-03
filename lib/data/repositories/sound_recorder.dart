import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class SoundRecorder {
  FlutterSoundRecorder? soundRecorder;
  bool isInitialized = false;

  bool get isRecording =>
      soundRecorder != null ? soundRecorder!.isRecording : false;

  Future init() async {
    soundRecorder = FlutterSoundRecorder();
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException("Microphone permission denied!");
    }
    await soundRecorder!.openAudioSession();
    isInitialized = true;
  }

  void dispose() {
    if (!isInitialized) return;
    soundRecorder!.closeAudioSession();
    soundRecorder = null;
    isInitialized = false;
  }

  Future record({required String pathToSave}) async {
    if (!isInitialized) return;
    await soundRecorder!.startRecorder(toFile: pathToSave);
  }

  Future stop() async {
    if (!isInitialized) return;
    await soundRecorder!.stopRecorder();
  }

  Future<void> delete({required String filePath}) async {
    if (!isInitialized) return;
    await soundRecorder!.deleteRecord(fileName: filePath);
  }
}

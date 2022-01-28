part of 'message_box_cubit.dart';

@immutable
abstract class MessageBoxState {}

class MessageBoxText extends MessageBoxState {}

class MessageBoxVoice extends MessageBoxState {}

class MessageBoxLoading extends MessageBoxState {
  final String loadingMsg;
  MessageBoxLoading({
    required this.loadingMsg,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MessageBoxLoading && other.loadingMsg == loadingMsg;
  }

  @override
  int get hashCode => loadingMsg.hashCode;

  @override
  String toString() => 'MessageBoxLoading(loadingMsg: $loadingMsg)';
}

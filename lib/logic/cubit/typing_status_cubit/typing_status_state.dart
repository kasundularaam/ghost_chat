part of 'typing_status_cubit.dart';

@immutable
abstract class TypingStatusState {}

class TypingStatusInitial extends TypingStatusState {}

class TypingStatusLoading extends TypingStatusState {}

class TypingStatusLoaded extends TypingStatusState {
  final String status;
  TypingStatusLoaded({
    required this.status,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TypingStatusLoaded && other.status == status;
  }

  @override
  int get hashCode => status.hashCode;

  @override
  String toString() => 'TypingStatusLoaded(status: $status)';
}

class TypingStatusFailed extends TypingStatusState {
  final String errorMsg;
  TypingStatusFailed({
    required this.errorMsg,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TypingStatusFailed && other.errorMsg == errorMsg;
  }

  @override
  int get hashCode => errorMsg.hashCode;

  @override
  String toString() => 'TypingStatusFailed(errorMsg: $errorMsg)';
}

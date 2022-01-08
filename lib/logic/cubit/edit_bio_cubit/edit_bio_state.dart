part of 'edit_bio_cubit.dart';

@immutable
abstract class EditBioState {}

class EditBioInitial extends EditBioState {}

class EditBioUpdating extends EditBioState {}

class EditBioSucceed extends EditBioState {}

class EditBioFailed extends EditBioState {
  final String errorMsg;
  EditBioFailed({
    required this.errorMsg,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EditBioFailed && other.errorMsg == errorMsg;
  }

  @override
  int get hashCode => errorMsg.hashCode;

  @override
  String toString() => 'EditBioFailed(errorMsg: $errorMsg)';
}

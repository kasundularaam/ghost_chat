import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'msg_del_set_time_state.dart';

class MsgDelSetTimeCubit extends Cubit<MsgDelSetTimeState> {
  MsgDelSetTimeCubit() : super(MsgDelSetTimeInitial());
}

import 'package:aplikasi_rw/services/like_status_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LikeStatusEvent {
  bool isLike;
  String idUser, idStatus;

  LikeStatusEvent({this.isLike, this.idStatus, this.idUser});
}

class LikeStatusState {
  Color colorButton;
  bool isLike;
  String numberLike;

  LikeStatusState({this.colorButton, this.isLike, this.numberLike});
}

class LikeStatusBloc extends Bloc<LikeStatusEvent, LikeStatusState> {
  LikeStatusBloc(LikeStatusState initialState) : super(initialState);

  // @override
  Stream<LikeStatusState> mapEventToState(LikeStatusEvent event) async* {
    int status = await LikeStatusService.isLike(
        idStatus: event.idStatus, idUser: event.idUser);
    String totalLike = await LikeStatusService.getLike(
        idStatus: event.idStatus, idUser: event.idUser);

    if (status >= 1) {
      yield (LikeStatusState(
          colorButton: Colors.red, isLike: true, numberLike: totalLike));
    } else {
      yield (LikeStatusState(
          colorButton: Colors.black, isLike: false, numberLike: '0'));
    }
  }
}

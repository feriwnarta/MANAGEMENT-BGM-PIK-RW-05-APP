import 'package:aplikasi_rw/model/status_user_model.dart';
import 'package:aplikasi_rw/services/status_user_services.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatusUserEvent {}

class StatusUserEventRefresh extends StatusUserEvent {}

abstract class StatusUserState {}

class StatusCommentRefresh extends StatusUserEventRefresh {}

class StatusUserUnitialized extends StatusUserState {}

class StatusUserLoaded extends StatusUserState {
  List<StatusUserModel> listStatusUser;
  bool isMaxReached;
  String idUser;

  StatusUserLoaded({this.listStatusUser, this.isMaxReached, this.idUser});

  // update max reached
  StatusUserLoaded copyWith(
      {List<StatusUserModel> listStatusUser,
      bool isMaxReached,
      String idUser}) {
    return StatusUserLoaded(
        listStatusUser: listStatusUser ?? this.listStatusUser,
        isMaxReached: isMaxReached ?? this.isMaxReached,
        idUser: idUser ?? this.idUser);
  }
}

class StatusCommentState extends StatusUserState {}

class StatusUserBloc extends Bloc<StatusUserEvent, StatusUserState> {
  StatusUserBloc(StatusUserState initialState) : super(initialState);

  // @override
  Stream<StatusUserState> mapEventToState(StatusUserEvent event) async* {
    List<StatusUserModel> listStatusUser;

    String idUser = await UserSecureStorage.getIdUser();

    if (event is StatusUserEventRefresh) {
      List<StatusUserModel> listStatusUserNew =
          await StatusUserServices.getDataApi(idUser, 0, 10);

      yield StatusUserLoaded(
          listStatusUser: listStatusUserNew,
          isMaxReached: false,
          idUser: idUser);
    }

    if (state is StatusUserUnitialized) {
      listStatusUser = await StatusUserServices.getDataApi(idUser, 0, 10);
      yield StatusUserLoaded(
          listStatusUser: listStatusUser, isMaxReached: false, idUser: idUser);
    } else {
      StatusUserLoaded statusLoaded = state as StatusUserLoaded;
      listStatusUser = await StatusUserServices.getDataApi(
          statusLoaded.idUser, statusLoaded.listStatusUser.length, 10);
      yield (listStatusUser.isEmpty)
          ? statusLoaded.copyWith(
              isMaxReached: true, idUser: statusLoaded.idUser)
          : StatusUserLoaded(
              listStatusUser: statusLoaded.listStatusUser + listStatusUser,
              isMaxReached: false,
              idUser: statusLoaded.idUser);
    }
  }
}

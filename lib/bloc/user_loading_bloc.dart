import 'package:aplikasi_rw/model/contractor_model.dart';
import 'package:aplikasi_rw/model/user_model.dart';
import 'package:aplikasi_rw/services/get_data_user_services.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/get_data_cordinator_services.dart';

class UserLoadingEvent {}

class UserLogOut extends UserLoadingEvent {}

abstract class UserLoadingState {}

class UserLoadingRefresh extends UserLoadingEvent {}

class UserLoadingUnitialized extends UserLoadingState {}

class UserSuccesLogin extends UserLoadingState {}

class UserNotLogin extends UserLoadingState {}

class UserLogin extends UserLoadingEvent {}

class UserLoadingInitialized extends UserLoadingState {
  String idUser, username, urlProfile;

  UserLoadingInitialized({this.idUser, this.urlProfile, this.username});
}

class ContractorInitialized extends UserLoadingState {
  String idContractor, nameContractor;

  ContractorInitialized({this.idContractor, this.nameContractor});
}

class CordinatorInitialized extends UserLoadingState {
  String idCordinator, nameCordinator;
  List<String> job;

  CordinatorInitialized({this.idCordinator, this.nameCordinator, this.job});
}

class UserLoadingBloc extends Bloc<UserLoadingEvent, UserLoadingState> {
  UserLoadingBloc(UserLoadingState initialState) : super(initialState);
  // @override
  Stream<UserLoadingState> mapEventToState(UserLoadingEvent event) async* {
    if (event is UserLogOut) {
      yield UserNotLogin();
    }

    if (event is UserLogin) {
      String idUser = await UserSecureStorage.getIdUser();
      UserModel userModel = await GetDataUserServices.getDataUser(idUser);
      yield UserLoadingInitialized(
          idUser: idUser,
          urlProfile: userModel.urlProfile,
          username: userModel.username);
    }

    if (event is UserLoadingRefresh) {
      String idUser = await UserSecureStorage.getIdUser();
      UserModel userModel = await GetDataUserServices.getDataUser(idUser);
      yield UserLoadingInitialized(
          idUser: idUser,
          urlProfile: userModel.urlProfile,
          username: userModel.username);
      yield UserLoadingUnitialized();
    }
    String status = await UserSecureStorage.getStatus();
    String user = await UserSecureStorage.getIdUser();

    if (status == null && user == null) {
      yield (UserNotLogin());
    }

    if (status != null) {
      if (status == 'user') {
        if (state is UserLoadingUnitialized) {
          String idUser = await UserSecureStorage.getIdUser();
          UserModel userModel = await GetDataUserServices.getDataUser(idUser);
          yield UserLoadingInitialized(
              idUser: idUser,
              urlProfile: userModel.urlProfile,
              username: userModel.username);
        } else {
          String idUser = await UserSecureStorage.getIdUser();
          UserModel userModel = await GetDataUserServices.getDataUser(idUser);
          yield UserLoadingInitialized(
              idUser: idUser,
              urlProfile: userModel.urlProfile,
              username: userModel.username);
        }
      } else if (status == 'cordinator') {
        if (state is UserLoadingUnitialized) {
          String idUser = await UserSecureStorage.getIdUser();
          CordinatorModel model =
              await GetDataCordinatorServices.getDataCordinator(idUser);
          yield (CordinatorInitialized(
              idCordinator: model.idCordinator,
              nameCordinator: model.nameCordinator,
              job: model.job));
        } else {
          String idUser = await UserSecureStorage.getIdUser();
          CordinatorModel model =
              await GetDataCordinatorServices.getDataCordinator(idUser);
          yield (CordinatorInitialized(
              idCordinator: model.idCordinator,
              nameCordinator: model.nameCordinator,
              job: model.job));
        }
      }
    }
  }
}

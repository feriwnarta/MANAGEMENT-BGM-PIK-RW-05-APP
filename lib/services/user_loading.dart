import 'package:aplikasi_rw/model/user_model.dart';
import 'package:aplikasi_rw/services/get_data_user_services.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';

class UserLoading {
  static Stream<Map<String, dynamic>> loadDataUser() async* {
    String idUser = await UserSecureStorage.getIdUser();
    UserModel userModel = await GetDataUserServices.getDataUser(idUser);
    String username = userModel.username;
    String urlProfile = userModel.urlProfile;

    Map<String, dynamic> dataUser = {
      'idUser' : idUser,
      'username' : username,
      'urlProfile' : urlProfile
    };

    yield dataUser;
  }
}
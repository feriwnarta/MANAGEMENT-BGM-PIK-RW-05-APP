import 'dart:convert';

import 'package:aplikasi_rw/model/contractor_model.dart';
import 'package:aplikasi_rw/model/user_model.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/services/get_data_contractor.dart';
import 'package:aplikasi_rw/services/get_data_cordinator_services.dart';
import 'package:aplikasi_rw/services/get_data_user_services.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class UserLoginController extends GetxController {
  RxString status = ''.obs;
  var userStatus = ''.obs;

  // user warga
  RxString idUser;
  var urlProfile = ''.obs;
  var username = ''.obs;

  // user cordinator
  var idCordinator = ''.obs;
  var nameCordinator = ''.obs;
  var job = <String>[].obs;

  // user contractor
  var idContractor = ''.obs;
  var nameContractor = ''.obs;
  var jobContractor = <String>[].obs;

  var accessManagement = false.obs;
  var accessWarga = false.obs;

  var statusServer = 'normal'.obs;
  var statusConnection = 'online'.obs;

  var otpWhenExit = false.obs;
  var noIpl = ''.obs;
  var email = ''.obs;
  var noTelp = ''.obs;

  void resetOtpWhenExit() {
    otpWhenExit = false.obs;
    noIpl = ''.obs;
    email = ''.obs;
    noTelp = ''.obs;
  }

  Future<void> checkServer() async {
    // String idUser = await UserSecureStorage.getIdUser();
    String url = '${ServerApp.url}src/status_server/dologin.php';

    var body = {'id_user': '123'};

    var response = await http.post(Uri.parse(url), body: jsonEncode(body));
    String message = jsonDecode(response.body);

    if (message.isCaseInsensitiveContainsAny('NORMAL')) {
      statusServer = 'normal'.obs;
    } else if (message.isCaseInsensitiveContainsAny('MAINTENANCE')) {
      statusServer = 'maintenance'.obs;
    }
  }

  void connect() {
    statusConnection = 'online'.obs;
  }

  Future<void> noConnection() async {
    statusConnection = 'offline'.obs;
  }

  Future<void> checkLogin() async {
    String idUser = await UserSecureStorage.getIdUser();
    String statusUser = await UserSecureStorage.getStatus();

    if (idUser != null && statusUser != null) {
      // cek status user apakah empty
      if (statusUser.isNotEmpty) {
        switch (statusUser) {
          case 'user':
            status = 'user'.obs;
            this.idUser = idUser.obs;
            UserModel userModel = await GetDataUserServices.getDataUser(idUser);
            if (userModel != null) {
              this.urlProfile = userModel.urlProfile.obs;
              this.username = userModel.username.obs;
            } else {
              status = 'logout'.obs;
              UserSecureStorage.deleteIdUser();
              UserSecureStorage.deleteStatus();
            }
            break;

          case 'cordinator':
            status = 'cordinator'.obs;
            this.idUser = idUser.obs;
            CordinatorModel cordinatorModel =
                await GetDataCordinatorServices.getDataCordinator(idUser);
            if (cordinatorModel != null) {
              this.nameCordinator = cordinatorModel.nameCordinator.obs;
              this.job = cordinatorModel.job.obs;
            } else {
              status = 'logout'.obs;
              UserSecureStorage.deleteIdUser();
              UserSecureStorage.deleteStatus();
            }
            break;
          case 'contractor':
            status = 'contractor'.obs;
            this.idUser = idUser.obs;
            ContractorModel contractorModel =
                await GetDataContractor.getDataContractor(idUser);
            if (contractorModel != null) {
              this.nameContractor = contractorModel.nameContractor.obs;
              this.jobContractor = contractorModel.job.obs;
            } else {
              status = 'logout'.obs;
              UserSecureStorage.deleteIdUser();
              UserSecureStorage.deleteStatus();
            }
            break;
          default:
            status = 'logout'.obs;
        }
      } else {
        status = 'logout'.obs;
      }
    } else {
      status = 'logout'.obs;
    }
  }

  Future<void> logout() async {
    if (idUser != null && status != null) {
      idUser = ''.obs;
      status = ''.obs;
      urlProfile = ''.obs;
      username = ''.obs;
      nameCordinator = ''.obs;
      job = <String>[].obs;
      accessManagement = false.obs;
    }
  }

  Future<void> loginCitizen() async {
    String idUser = await UserSecureStorage.getIdUser();
    String statusUser = await UserSecureStorage.getStatus();
    if (idUser != null && statusUser != null) {
      // status = 'user'.obs;
      UserModel userModel = await GetDataUserServices.getDataUser(idUser);
      this.urlProfile = userModel.urlProfile.obs;
      this.username = userModel.username.obs;
    }
  }

  Future<void> loginCordinator() async {
    String idUser = await UserSecureStorage.getIdUser();
    String statusUser = await UserSecureStorage.getStatus();
    if (idUser != null && statusUser != null) {
      status = 'cordinator'.obs;
      CordinatorModel cordinatorModel =
          await GetDataCordinatorServices.getDataCordinator(idUser);
      this.nameCordinator = cordinatorModel.nameCordinator.obs;
      this.job = cordinatorModel.job.obs;
    }
  }

  Future<void> loginContractor() async {
    String idUser = await UserSecureStorage.getIdUser();
    String statusUser = await UserSecureStorage.getStatus();
    if (idUser != null && statusUser != null) {
      status = 'contractor'.obs;
      print('ID USER = $idUser \n STATUS USER = ${status.value}');
      ContractorModel contractorModel =
          await GetDataContractor.getDataContractor(idUser);
      this.nameContractor = contractorModel.nameContractor.obs;
      this.jobContractor = contractorModel.job.obs;
    }
  }

  Future<CordinatorModel> getCordinatorModel(String idUser) async {
    CordinatorModel model =
        await GetDataCordinatorServices.getDataCordinator(idUser);
    return Future.value(model);
  }

  Future<UserModel> getUserModel(String idUser) async {
    UserModel userModel = await GetDataUserServices.getDataUser(idUser);
    return Future.value(userModel);
  }
}

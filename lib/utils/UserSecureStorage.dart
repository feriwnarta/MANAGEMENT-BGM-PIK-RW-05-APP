import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage {
  static const _STORAGE = FlutterSecureStorage();
  static const _KEYIDUSER = 'idUser';
  static const _KEYSTATUSUSER = 'status';

  static Future setIdUser(String idUser) async =>
      await _STORAGE.write(key: _KEYIDUSER, value: idUser);
  static Future<String> getIdUser() async =>
      await _STORAGE.read(key: _KEYIDUSER);
  static Future deleteIdUser() async {
    String idUser = await UserSecureStorage.getIdUser();
    if (idUser != null && idUser.isNotEmpty) {
      await _STORAGE.delete(key: _KEYIDUSER);
    }
  }

  static Future setKeyValue({String key, String value}) async {
    await _STORAGE.write(key: key, value: value);
  }

  static Future<String> readKey({String key}) async {
    return await _STORAGE.read(key: key);
  }

  static Future deleteKey({String key}) async {
    await _STORAGE.delete(key: key);
  }

  static Future setStatusLogin(String status) async =>
      await _STORAGE.write(key: _KEYSTATUSUSER, value: status);
  static Future<String> getStatus() async =>
      await _STORAGE.read(key: _KEYSTATUSUSER);
  static Future deleteStatus() async {
    String status = await UserSecureStorage.getStatus();
    if (status != null && status.isNotEmpty) {
      await _STORAGE.delete(key: _KEYSTATUSUSER);
    }
  }

  static Future setPosition(double position) async =>
      await _STORAGE.write(key: 'POSITION', value: position.toString());
  static Future<String> getPoisition() async =>
      await _STORAGE.read(key: 'POSITION');
}

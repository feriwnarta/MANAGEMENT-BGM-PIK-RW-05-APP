import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

class CheckSession {
  static const String _URLCHECKSESSION = 'http://192.168.3.87/nextg_mobileapp/src/check_session.php';
  String _message;
  var _response;

  Future<bool> checkIsLogin(String _idUserFromSecureStorage) async {
    var data = {
      'id_user' : _idUserFromSecureStorage
    };

    try {
      _response = await http.post(Uri.parse(_URLCHECKSESSION), body: json.encode(data));
       if (_response.statusCode >= 400) { 
         return false;
       } 

       if(_response.body.isNotEmpty) {
         _message = json.decode(_response.body);
         if(_message == 'OK') {
           return true;
         } else {
           print('$_message');
           return false;
         }
       } else {
         print('body check session is empty');
         return false;
       }

    } on SocketException {} on HttpException {}

    return false;
  }    


  }

  // Future<bool> checkSessionId(String _idUserFromSecureStorage) async {
  //   var data = {
  //     'id_user' : _idUserFromSecureStorage
  //   };

  //   try {
  //     _response = await http.post(_URLCHECKSESSION, body: json.encode(data));
  //      if (_response.statusCode >= 400) { 
  //        return false;
  //      } 

  //      if(_response.body.isNotEmpty) {
  //        _message = json.decode(_response.body);
  //        if(_message == 'OKE') {
  //          print('login');
  //          return true;
  //        } else {
  //          print('log out');
  //          print('$_message');
  //          return false;
  //        }
  //      } else {
  //        print('body check session is empty');
  //        return false;
  //      }

  //   } on SocketException {} on HttpException {}

  //   return false;
  // }
  // }
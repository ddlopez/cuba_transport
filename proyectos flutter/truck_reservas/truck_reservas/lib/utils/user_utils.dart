import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:truck_reservas/models/user_model.dart';

import 'package:http/http.dart' as http;
import 'package:truck_reservas/providers/user_provider.dart';
import 'package:truck_reservas/utils/owner_token.dart';
import 'package:truck_reservas/utils/subir_fotos.dart';

import 'app_url.dart';

class UserUtils {
  static Future getUserInfo(BuildContext context) async {
    print('OBTENIENDO USER INFO');
    String? token = await OwnerToken.load();

    if (token == 'NO_TOKEN') {
      return {
        'user': null,
        'error': 'No se pudo obtener el token para realizar la consulta'
      };
    }

    try {
      final response = await http.get(
          Uri.http(
            AppUrl.baseURL,
            AppUrl.userInfo,
          ),
          headers: {
            "x-token": "$token",
            "Content-Type": "application/json"
          }).timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        final decodeData = jsonDecode(response.body);
        Owner user = Owner.fromJson(decodeData);
        await Future.delayed(const Duration(milliseconds: 500), () {
          Provider.of<OwnerProvider>(context, listen: false).owner = user;
        });

        return {'user': user, 'error': null};
      } else {
        final error = jsonDecode(response.body);
        if (response.statusCode == 403) {
          OwnerToken.delete();
        }

        return {
          'user': null,
          'error': '${response.statusCode} ${error['message']}',
          'errorBackend': true
        };
      }
    } on SocketException {
      return {
        'user': null,
        'error':
            'No se ha podido conectar, revise su conexión y vuelva a intentar'
      };
    } on TimeoutException {
      return {
        'user': null,
        'error': 'Se ha exedido el tiempo de espera de conexión'
      };
    } catch (e) {
      return {'user': null, 'error': e.toString()};
    }
  }

  static Future updateUserInfo(Map body) async {
    String? token = await OwnerToken.load();

    if (token == 'NO_TOKEN') {
      return {
        'user': null,
        'error': 'No se pudo obtener el token para realizar la consulta'
      };
    }

    try {
      final response = await http.put(
          Uri.http(
            AppUrl.baseURL,
            AppUrl.userInfo,
          ),
          body: jsonEncode(body),
          headers: {
            "x-token": "$token",
            "Content-Type": "application/json"
          }).timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        final decodeData = jsonDecode(response.body);
        Owner user = Owner.fromJson(decodeData);

        return {
          'user': user,
          'error': null,
        };
      } else {
        final error = jsonDecode(response.body);
        if (response.statusCode == 403) {
          OwnerToken.delete();
        }

        return {
          'user': null,
          'error': '${response.statusCode} ${error['message']}',
          'errorBackend': true
        };
      }
    } on SocketException {
      return {
        'user': null,
        'error':
            'No se ha podido conectar, revise su conexión y vuelva a intentar'
      };
    } on TimeoutException {
      return {
        'user': null,
        'error': 'Se ha exedido el tiempo de espera de conexión'
      };
    } catch (e) {
      return {'user': null, 'error': e.toString()};
    }
  }

  static Future<Map> loginAndRegister(
      String username, String password, bool login) async {
    try {
      final response = await http.post(
          Uri.http(
            AppUrl.baseURL,
            login == true ? AppUrl.login : AppUrl.registro,
          ),
          body: jsonEncode({"username": username, "password": password}),
          headers: {"Content-Type": "application/json"}).timeout(
        const Duration(seconds: 15),
      );

      if (response.statusCode == 200) {
        final decodeData = jsonDecode(response.body);

        OwnerToken.save(decodeData['token']);
        Owner user = Owner.fromJson(decodeData);

        return {'user': user, 'error': null};
      } else {
        final error = jsonDecode(response.body);

        return {
          'user': null,
          'error': '${response.statusCode} ${error['msg']}',
          'errorBackend': true
        };
      }
    } on SocketException {
      return {
        'user': null,
        'error':
            'No se ha podido conectar, revise su conexión y vuelva a intentar'
      };
    } on TimeoutException {
      return {
        'user': null,
        'error': 'Se ha exedido el tiempo de espera de conexión'
      };
    } catch (e) {
      return {'user': null, 'error': e.toString()};
    }
  }

  static Future<List> subirFotos(List<Map> fotos) async {
    List errores = [];
    for (var element in fotos) {
      final resp = await HttpUploadService.uploadPhotos(
          element['path'], element['ruta']);
      if (resp == 'error') {
        errores.add(element['tipo']);
      }
    }
    return errores;
  }
}

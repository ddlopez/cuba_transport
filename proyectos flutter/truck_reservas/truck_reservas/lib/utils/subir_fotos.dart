import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:truck_reservas/utils/app_url.dart';
import 'package:truck_reservas/utils/owner_token.dart';

class HttpUploadService {
  static Future<String> uploadPhotos(String path, String ruta) async {
    try {
      String? token = await OwnerToken.load();
      Uri uri = Uri.http(AppUrl.baseURL, ruta);
      http.MultipartRequest request = http.MultipartRequest('PUT', uri);
      request.files.add(await http.MultipartFile.fromPath('archivo', path));
      request.headers.addAll({"x-token": "$token"});

      http.StreamedResponse response =
          await request.send().timeout(const Duration(seconds: 15));
      var responseBytes = await response.stream.toBytes();
      var responseString = utf8.decode(responseBytes);

      if (response.statusCode == 201) {
        return 'OK';
      } else {
        return 'Error';
      }
    } on SocketException {
      return 'No se ha podido conectar, revise su conexión y vuelva a intentar';
    } on TimeoutException {
      return 'Se ha exedido el tiempo de espera de conexión';
    } catch (e) {
      log(e.toString());
      return e.toString();
    }
  }

  static List<Map> generarListFotos(
      {XFile? foto,
      XFile? ciFront,
      XFile? ciBack,
      XFile? licFront,
      XFile? licBack}) {
    List<Map> listaFotos = [];
    if (foto != null) {
      listaFotos.add(
          {"path": foto.path, "ruta": AppUrl.fotoAvatar, "tipo": "avatar"});
    }
    if (ciFront != null) {
      listaFotos.add({
        "path": ciFront.path,
        "ruta": AppUrl.fotoCiFront,
        "tipo": "ci_front"
      });
    }
    if (ciBack != null) {
      listaFotos.add(
          {"path": ciBack.path, "ruta": AppUrl.fotoCiBack, "tipo": "ci_back"});
    }
    if (licFront != null) {
      listaFotos.add({
        "path": licFront.path,
        "ruta": AppUrl.fotoLicFront,
        "tipo": "lic_front"
      });
    }
    if (licBack != null) {
      listaFotos.add({
        "path": licBack.path,
        "ruta": AppUrl.fotoLicBack,
        "tipo": "lic_back"
      });
    }
    return listaFotos;
  }
}

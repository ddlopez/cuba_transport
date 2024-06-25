import 'package:truck_reservas/utils/app_url.dart';

class Owner {
  String? id;
  String? token;
  String? name;
  String? userName;
  String? email;
  String? phone;
  String? avatar;
  String? ci;
  String? licencia;
  int? status;
  bool? owner;
  String? fotoCiFront;
  String? fotoCiBack;
  String? fotoLicFront;
  String? fotoLicBack;

  Owner(
      {this.id,
      this.token,
      this.name,
      this.userName,
      this.email,
      this.phone,
      this.avatar,
      this.ci,
      this.licencia,
      this.status,
      this.owner,
      this.fotoCiFront,
      this.fotoCiBack,
      this.fotoLicFront,
      this.fotoLicBack});

  factory Owner.fromJson(Map<String, dynamic> responseData) {
    //pal login
    return Owner(
      id: responseData['uuid'],
      name: responseData['Nombre_Ap'],
      userName: responseData['username'],
      email: responseData['email'],
      phone: responseData['phone'],
      ci: responseData['ci'],
      licencia: responseData['licencia'],
      status: responseData['status'],
      owner: responseData['owner'],
      avatar: responseData['avatar'] != null
          ? "http://${AppUrl.baseURL}${AppUrl.fotoAvatar}"
          : null,
      fotoCiFront: responseData['ci_front'] != null
          ? "http://${AppUrl.baseURL}${AppUrl.fotoCiFront}"
          : null,
      fotoCiBack: responseData['ci_back'] != null
          ? "http://${AppUrl.baseURL}${AppUrl.fotoCiBack}"
          : null,
      fotoLicFront: responseData['licencia_front'] != null
          ? "http://${AppUrl.baseURL}${AppUrl.fotoLicFront}"
          : null,
      fotoLicBack: responseData['licencia_back'] != null
          ? "http://${AppUrl.baseURL}${AppUrl.fotoLicBack}"
          : null,
    );
  }
}

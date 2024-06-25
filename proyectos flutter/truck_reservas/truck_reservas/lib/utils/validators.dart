import 'package:image_picker/image_picker.dart';
import 'package:truck_reservas/models/user_model.dart';

class Validators {
  static String? validarUser(String? value) {
    final caracteresPermitidos = RegExp(r'^[a-z0-9]+$');
    final soloNumeros = RegExp(r'^[0-9]+$');
    if (soloNumeros.hasMatch(value!)) {
      return 'El nombre de usuario debe contener letras minúsculas';
    }
    if (caracteresPermitidos.hasMatch(value)) {
      return null;
    } else {
      return 'Nombre de usuario no válido';
    }
  }

  static String? validarPassword(String? value) {
    RegExp regex = RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~.]).{8,}$');

    if (regex.hasMatch(value!)) {
      return null;
    } else {
      return 'Contraseña no válida';
    }
  }

  static String? validarPasswordRepetido(String? pass1, String? pass2) {
    if (pass1 == pass2) {
      return null;
    } else {
      return 'Las contraseñas no coinciden';
    }
  }

  static String? validarCI(String? ci) {
    final soloNumeros = RegExp(r'^[0-9]+$');

    if (ci!.length < 11) {
      return "Debe contener 11 números";
    }
    if (ci.length > 11) {
      return "Debe contener 11 números";
    }
    if (soloNumeros.hasMatch(ci)) {
      return null;
    } else {
      return 'CI no válido';
    }
  }

  static String? validarPhone(String? phone) {
    final soloNumeros = RegExp(r'^[0-9]+$');

    if (phone!.length < 8) {
      return "Debe contener 8 números";
    }
    if (phone.length > 8) {
      return "Debe contener 8 números";
    }
    if (soloNumeros.hasMatch(phone)) {
      return null;
    } else {
      return 'phone no válido';
    }
  }

  static String? validarEmail(String? mail) {
    final validMail = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    if (validMail.hasMatch(mail!)) {
      return null;
    } else {
      return 'mail no válido';
    }
  }

  static bool userShouldCompleteInfo(Owner owner) {
    if (owner.name == null ||
        owner.ci == null ||
        owner.phone == null ||
        owner.fotoCiFront == null ||
        owner.fotoCiBack == null) {
      return true;
    }
    if (owner.owner == false &&
        (owner.fotoLicFront == null ||
            owner.fotoLicBack == null ||
            owner.licencia == null)) {
      return true;
    }
    return false;
  }

  static bool shouldApearSaveButton(
      Owner owner,
      String name,
      String ci,
      String lic,
      String phone,
      String email,
      bool ownerStatus,
      XFile? avatar,
      XFile? licfront,
      XFile? licback,
      XFile? cifront,
      XFile? ciback) {
    bool _ownerStatus = owner.owner ?? false;
    String _name = owner.name ?? '';
    String _ci = owner.ci ?? '';
    String _lic = owner.licencia ?? '';
    String _phone = owner.phone ?? '';
    String _email = owner.email ?? '';

    if (avatar != null ||
        licfront != null ||
        licback != null ||
        cifront != null ||
        ciback != null) {
      return true;
    }
    if (_name != name ||
        _ownerStatus != ownerStatus ||
        _ci != ci ||
        _lic != lic ||
        _phone != phone ||
        _email != email) {
      return true;
    }
    return false;
  }
}

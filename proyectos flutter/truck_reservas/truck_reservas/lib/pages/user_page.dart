import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:truck_reservas/providers/user_provider.dart';
import 'package:truck_reservas/utils/subir_fotos.dart';
import 'package:truck_reservas/utils/user_utils.dart';
import 'package:truck_reservas/utils/validators.dart';
import 'package:truck_reservas/widgets/mensajes.dart';

import '../models/user_model.dart';
import '../utils/app_url.dart';
import '../utils/owner_token.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final ImagePicker _picker = ImagePicker();
  bool salvadoConExito = false;
  bool loading = false;
  bool ownerOchofer = false;
  bool showSaveButton = false;
  bool enableEditing = true;
  CroppedFile? croppedFile;
  XFile? foto, ciFront, ciBack, licFront, licBack;
  String? username, fotoURL, ciFrontURL, ciBackURL, licFrontURL, licBackURL;
  TextEditingController controllerNombre = TextEditingController();
  TextEditingController controllerCI = TextEditingController();
  TextEditingController controllerLicencia = TextEditingController();
  TextEditingController controllerPhone = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  TextEditingController controllerMail = TextEditingController();

  @override
  void initState() {
    Owner ownerUser = Provider.of<OwnerProvider>(context, listen: false).owner;
    if (ownerUser.status == 2) {
      enableEditing = false;
    }
    ownerOchofer = ownerUser.owner ?? false;
    controllerNombre.text = ownerUser.name ?? '';
    controllerCI.text = ownerUser.ci ?? '';
    controllerLicencia.text = ownerUser.licencia ?? '';
    controllerPhone.text = ownerUser.phone ?? '';
    controllerMail.text = ownerUser.email ?? '';
    username = ownerUser.userName;
    fotoURL = ownerUser.avatar;
    ciFrontURL = ownerUser.fotoCiFront;
    ciBackURL = ownerUser.fotoCiBack;
    licFrontURL = ownerUser.fotoLicFront;
    licBackURL = ownerUser.fotoLicBack;
    super.initState();
  }

  @override
  void dispose() {
    controllerNombre.dispose();
    controllerCI.dispose();
    controllerLicencia.dispose();
    controllerMail.dispose();
    controllerPhone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (salvadoConExito) {
          return true;
        }
        if (!showSaveButton) {
          return true;
        }
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: Image.asset(
                'assets/warning.png',
                height: 100,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Estás seguro de salir sin guardar?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Puedes guardar los cambios en el botón que aparece abajo a la derecha',
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text(
                    'Si',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text(
                    'No',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            );
          },
        );
        return shouldPop!;
      },
      child: Scaffold(
          // extendBodyBehindAppBar: true,
          body: body(),
          backgroundColor: Colors.grey[300],
          floatingActionButton: saveButton()),
    );
  }

  Widget body() {
    return Stack(
      children: [containerFondo(), datosDeluserForm(), loadingContainer()],
    );
  }

  Widget containerFondo() {
    return Positioned(
        top: 0,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.4,
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromRGBO(36, 16, 65, 1),
                Color.fromRGBO(46, 18, 71, 1),
                Color.fromRGBO(56, 1, 58, 1),
              ], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              )),
        ));
  }

  Widget datosDeluserForm() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        fotoUser(),
        SliverList(
            delegate: SliverChildListDelegate([
          Container(
            margin: const EdgeInsets.only(left: 25, right: 25, bottom: 40),
            padding: const EdgeInsets.all(15),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 3,
                  // offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    'Perfil de usuario',
                    style: TextStyle(fontSize: 22, color: Colors.black),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  textfieldCreator(
                      controllerNombre,
                      'Nombre y apellidos',
                      const Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      'name'),
                  const SizedBox(
                    height: 15,
                  ),
                  textfieldCreator(
                      controllerCI,
                      'Carnet de identidad',
                      const Icon(
                        Icons.list_alt_sharp,
                        color: Colors.white,
                      ),
                      'CI'),
                  const SizedBox(
                    height: 15,
                  ),
                  textfieldCreator(
                      controllerLicencia,
                      'Licencia de conducción*',
                      const Icon(
                        Icons.directions_car,
                        color: Colors.white,
                      ),
                      'licencia'),
                  const SizedBox(
                    height: 15,
                  ),
                  textfieldCreator(
                      controllerPhone,
                      'Número de teléfono',
                      const Icon(
                        Icons.phone,
                        color: Colors.white,
                      ),
                      'phone'),
                  const SizedBox(
                    height: 15,
                  ),
                  textfieldCreator(
                      controllerMail,
                      'Correo electónico (opcional)*',
                      const Icon(
                        Icons.mail,
                        color: Colors.white,
                      ),
                      'mail'),
                  const SizedBox(
                    height: 15,
                  ),
                  fotosDeDocumentos(),
                  const SizedBox(
                    height: 40,
                  ),
                  choferOwner(),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          )
        ])),
      ],
    );
  }

  Widget textfieldCreator(TextEditingController controller, String labelText,
      Icon icon, String tipo) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
            child: Text(
              labelText,
              style: const TextStyle(
                  color: Color.fromRGBO(56, 1, 58, 1),
                  fontWeight: FontWeight.bold),
            ),
          ),
          TextFormField(
            onChanged: (value) {
              setState(() {});
            },
            validator: (value) {
              if (ownerOchofer && value == '' && tipo == 'licencia') {
                return null;
              }
              if ((value == null || value == '') && tipo != 'mail') {
                return 'Rellena este campo';
              } else if (tipo == 'CI') {
                return Validators.validarCI(value);
              } else if (tipo == 'licencia') {
                return Validators.validarCI(value);
              } else if (tipo == 'mail') {
                if (value == '') {
                  return null;
                }
                return Validators.validarEmail(value);
              } else if (tipo == 'phone') {
                return Validators.validarPhone(value);
              }
              return null;
            },
            enabled: tipo == 'phone' || tipo == 'mail' ? true : enableEditing,
            maxLength: tipo == 'CI' || tipo == 'licencia'
                ? 11
                : tipo == 'phone'
                    ? 8
                    : null,
            controller: controller,
            keyboardType: tipo == 'CI' || tipo == 'licencia' || tipo == 'phone'
                ? TextInputType.number
                : tipo == 'mail'
                    ? TextInputType.emailAddress
                    : null,
            inputFormatters: tipo == 'CI' ||
                    tipo == 'licencia' ||
                    tipo == 'phone'
                ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
                : null, // Only numbers can be entered
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
                counterText: "",
                contentPadding: EdgeInsets.all(0),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(30.0),
                  ),
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(30.0),
                  ),
                ),
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(30.0),
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 1, color: Color.fromRGBO(31, 46, 75, 1)),
                  borderRadius: BorderRadius.all(
                    Radius.circular(30.0),
                  ),
                ),
                disabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 1, color: Color.fromRGBO(31, 46, 75, 1)),
                  borderRadius: BorderRadius.all(
                    Radius.circular(30.0),
                  ),
                ),
                suffixIcon: !enableEditing
                    ? const Icon(
                        Icons.check,
                        color: Color.fromRGBO(31, 46, 75, 1),
                      )
                    : null,
                prefixIcon: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [
                        Color.fromRGBO(36, 16, 65, 1),
                        Color.fromRGBO(94, 37, 143, 1),
                        Color.fromRGBO(185, 2, 191, 1),
                      ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    ),
                    child: icon),
                counterStyle: const TextStyle(
                  color: Color.fromRGBO(31, 46, 75, 1),
                )),
          ),
        ],
      ),
    );
  }

  Widget fotosDeDocumentos() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 200,
        width: MediaQuery.of(context).size.width - 80,
        decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    if (!enableEditing) {
                      return;
                    }
                    imageSourcePicker(true, 'ci_front');
                  },
                  child: Stack(
                    children: [
                      Container(
                          width: (MediaQuery.of(context).size.width - 80) / 2,
                          height: 100,
                          color: Colors.grey,
                          child: ciFront == null
                              ? ciFrontURL != null
                                  //la logica es: si hay foto desde el backend muestrala
                                  // a menos q el user la updatee, en ese caso
                                  //muestra la local, si no hay ninguna muestra
                                  //el container
                                  ? containerFotoNetwork(ciFrontURL)
                                  : containerNofoto()
                              : containerFotoFIle(ciFront!.path, 'ci_front')),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          width: (MediaQuery.of(context).size.width - 80) / 2,
                          height: 25,
                          color: Colors.black.withOpacity(0.5),
                          child: const Text(
                            'C.I. frente',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (!enableEditing) {
                      return;
                    }
                    imageSourcePicker(true, 'ci_back');
                  },
                  child: Stack(
                    children: [
                      Container(
                          width: (MediaQuery.of(context).size.width - 80) / 2,
                          height: 100,
                          color: Colors.grey,
                          child: ciBack == null
                              ? ciBackURL != null
                                  ? containerFotoNetwork(ciBackURL)
                                  : containerNofoto()
                              : containerFotoFIle(ciBack!.path, 'ci_back')),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          width: (MediaQuery.of(context).size.width - 80) / 2,
                          height: 25,
                          color: Colors.black.withOpacity(0.5),
                          child: const Text(
                            'C.I. atás',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    if (!enableEditing) {
                      return;
                    }
                    imageSourcePicker(true, 'lic_front');
                  },
                  child: Stack(
                    children: [
                      Container(
                          width: (MediaQuery.of(context).size.width - 80) / 2,
                          height: 100,
                          color: Colors.grey,
                          child: licFront == null
                              ? licFrontURL != null
                                  ? containerFotoNetwork(licFrontURL)
                                  : containerNofoto()
                              : containerFotoFIle(licFront!.path, 'lic_front')),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          width: (MediaQuery.of(context).size.width - 80) / 2,
                          height: 25,
                          color: Colors.black.withOpacity(0.5),
                          child: const Text(
                            'Lic. frente',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (!enableEditing) {
                      return;
                    }
                    imageSourcePicker(true, 'lic_back');
                  },
                  child: Stack(
                    children: [
                      Container(
                          width: (MediaQuery.of(context).size.width - 80) / 2,
                          height: 100,
                          color: Colors.grey,
                          child: licBack == null
                              ? licBackURL != null
                                  ? containerFotoNetwork(licBackURL)
                                  : containerNofoto()
                              : containerFotoFIle(licBack!.path, 'lic_back')),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          width: (MediaQuery.of(context).size.width - 80) / 2,
                          height: 25,
                          color: Colors.black.withOpacity(0.5),
                          child: const Text(
                            'Lic. atrás',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget choferOwner() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        AnimatedScale(
          duration: const Duration(milliseconds: 150),
          scale: ownerOchofer == false ? 1.1 : 1,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  ownerOchofer = false;
                  setState(() {});
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  height: (MediaQuery.of(context).size.width - 100) / 2,
                  width: (MediaQuery.of(context).size.width - 100) / 2,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: ownerOchofer == false
                          ? Colors.grey[400]
                          : Colors.white,
                      border: Border.all(
                          width: ownerOchofer ? 2.0 : 4.0,
                          color: ownerOchofer == false
                              ? Colors.blue
                              : Colors.black54)),
                  child: Image.asset(
                    'assets/driver.png',
                    height: (MediaQuery.of(context).size.width - 100) / 2,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Text(
                'Chofer',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        AnimatedScale(
          duration: const Duration(milliseconds: 150),
          scale: ownerOchofer == true ? 1.1 : 1,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  ownerOchofer = true;
                  setState(() {});
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  height: (MediaQuery.of(context).size.width - 100) / 2,
                  width: (MediaQuery.of(context).size.width - 100) / 2,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: ownerOchofer == true
                          ? Colors.grey[400]
                          : Colors.white,
                      border: Border.all(
                          width: !ownerOchofer ? 2.0 : 4.0,
                          color: ownerOchofer == true
                              ? Colors.blue
                              : Colors.black54)),
                  child: Image.asset(
                    'assets/man.png',
                    height: (MediaQuery.of(context).size.width - 90) / 2,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Text(
                'Propietario',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget containerNofoto() {
    return Container(
      decoration:
          BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
      child: const Center(
          child: Text(
        'Toca para añadir una foto',
        style: TextStyle(
            color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
      )),
    );
  }

  Widget containerFotoFIle(String? path, String fotoAborrar) {
    return Stack(
      children: [
        SizedBox(
          height: 100,
          width: (MediaQuery.of(context).size.width - 80) / 2,
          child: Image.file(
            File(path!),
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              onPressed: () {
                deleteFoto(fotoAborrar);
              },
              icon: const CircleAvatar(
                backgroundColor: Color.fromRGBO(56, 1, 58, 1),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            )),
      ],
    );
  }

  Widget containerFotoNetwork(String? url) {
    return FutureBuilder(
        future: OwnerToken.load(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return CachedNetworkImage(
              httpHeaders: {"x-token": snapshot.data},
              fit: BoxFit.cover,
              imageUrl: url!,
              placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(
                color: Colors.white,
              )),
              errorWidget: (context, url, error) =>
                  const Center(child: Icon(Icons.error)),
            );
          }
          return SizedBox(
            height: 100,
            width: (MediaQuery.of(context).size.width - 80) / 2,
          );
        });
  }

  void deleteFoto(String foto) {
    if (foto == 'ci_front') {
      ciFront = null;
    } else if (foto == 'ci_back') {
      ciBack = null;
    } else if (foto == 'lic_front') {
      licFront = null;
    } else if (foto == 'lic_back') {
      licBack = null;
    }
    setState(() {});
  }

  Widget fotoUser() {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.transparent,
      expandedHeight: MediaQuery.of(context).size.height * 0.25,
      floating: false,
      pinned: false,
      flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          background: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Stack(children: [
                    croppedFile == null
                        ? fotoURL != null
                            ? FutureBuilder(
                                future: OwnerToken.load(),
                                builder: (context, AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    return CircleAvatar(
                                        // backgroundColor: Color(0xff00A3FF),
                                        radius: 70.0,
                                        // backgroundColor: Color(0xff00A3FF),
                                        backgroundImage: NetworkImage(fotoURL!,
                                            headers: {
                                              "x-token": snapshot.data
                                            }));
                                  }
                                  return const CircleAvatar(
                                      // backgroundColor: Color(0xff00A3FF),
                                      radius: 70.0,
                                      backgroundColor: Colors.grey,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      ));
                                })
                            : const CircleAvatar(
                                // backgroundColor: Color(0xff00A3FF),
                                radius: 70.0,
                                // backgroundColor: Color(0xff00A3FF),
                                backgroundImage:
                                    AssetImage('assets/picture.png'))
                        : CircleAvatar(
                            // backgroundColor: Color(0xff00A3FF),
                            radius: 70.0,
                            // backgroundColor: Color(0xff00A3FF),
                            backgroundImage:
                                FileImage(File(croppedFile!.path))),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: IconButton(
                        icon: const CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 20.0,
                          child: Icon(
                            Icons.add_a_photo,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          imageSourcePicker(false, null);
                        },
                      ),
                    )
                  ]),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  username ?? '',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                )
              ],
            ),
          )),
    );
  }

  void imageSourcePicker(bool container, String? tipo) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        )),
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Desde donde vas a subir las imagenes?',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () {
                        Navigator.pop(context);
                        if (container) {
                          pickImageCOntainer('camara', tipo);
                        } else {
                          pickImage('camara');
                        }
                      },
                      splashColor: Colors.black45,
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/camera.png',
                            height: 50,
                          ),
                          Text(
                            'Cámara',
                            style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(50),
                      splashColor: Colors.black45,
                      onTap: () {
                        Navigator.pop(context);
                        if (container) {
                          pickImageCOntainer('galeria', tipo);
                        } else {
                          pickImage('galeria');
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/gallery.png',
                            height: 50,
                          ),
                          Text(
                            'Galería',
                            style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          );
        });
  }

  Future<void> pickImage(String source) async {
    try {
      if (source == 'galeria') {
        foto = await _picker.pickImage(
            source: ImageSource.gallery, imageQuality: 40);
      } else if (source == 'camara') {
        foto = await _picker.pickImage(
            source: ImageSource.camera, imageQuality: 40);
      }

      if (foto == null) {
        return;
      }
      croppedFile = await ImageCropper().cropImage(
        sourcePath: foto!.path,
        cropStyle: CropStyle.circle,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Ajusta tu imagen',
              toolbarColor: Colors.black,
              toolbarWidgetColor: Colors.white,
              activeControlsWidgetColor: Colors.red,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Ajusta tu imagen',
          ),
        ],
      );
    } catch (e) {
      //TODO agregar un scaffold messenger pa los errores

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 3), content: Text(e.toString())));
    }

    setState(() {});
  }

  Future<void> pickImageCOntainer(String source, String? tipo) async {
    try {
      XFile? fotoDOc;
      if (source == 'galeria') {
        fotoDOc = await _picker.pickImage(
            source: ImageSource.gallery, imageQuality: 40);
      } else if (source == 'camara') {
        fotoDOc = await _picker.pickImage(
            source: ImageSource.camera, imageQuality: 40);
      }

      if (fotoDOc == null) {
        return;
      }
      if (tipo == 'ci_front') {
        ciFront = fotoDOc;
      }
      if (tipo == 'ci_back') {
        ciBack = fotoDOc;
      }
      if (tipo == 'lic_front') {
        licFront = fotoDOc;
      }
      if (tipo == 'lic_back') {
        licBack = fotoDOc;
      }
      setState(() {});
    } catch (e) {
      //TODO agregar un scaffold messenger pa los errores

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 3), content: Text(e.toString())));
    }

    setState(() {});
  }

  Widget? saveButton() {
    Owner owner = Provider.of<OwnerProvider>(context, listen: false).owner;
    bool shouldAppear = Validators.shouldApearSaveButton(
        owner,
        controllerNombre.text,
        controllerCI.text,
        controllerLicencia.text,
        controllerPhone.text,
        controllerMail.text,
        ownerOchofer,
        foto,
        licFront,
        licBack,
        ciFront,
        ciBack);
    if (shouldAppear) {
      showSaveButton = true;
      return AnimatedOpacity(
        opacity: shouldAppear ? 1 : 0,
        duration: const Duration(milliseconds: 500),
        curve: shouldAppear ? Curves.bounceIn : Curves.bounceInOut,
        child: FloatingActionButton(
          backgroundColor: const Color.fromRGBO(56, 1, 58, 1),
          onPressed: () {
            guardarCambios();
          },
          child: const Icon(Icons.save),
        ),
      );
    }
    showSaveButton = false;
    return null;
  }

  Widget loadingContainer() {
    if (!loading) {
      return const SizedBox();
    }
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
      child: const SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: SpinKitThreeBounce(
            color: Colors.white,
            size: 35.0,
          ),
        ),
      ),
    );
  }

  void guardarCambios() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (ownerOchofer == false) {
      if ((licFront == null && licFrontURL == null) ||
          (licBack == null && licBackURL == null)) {
        Message.showSnackBarCustom(
            context: context,
            error: true,
            sms:
                'Como chofer, debe agregar fotos de su licencia de conducción');
        return;
      }
    }
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      loading = true;
    });
    try {
      Map bodyData = {
        "owner": ownerOchofer,
        "Nombre_Ap": controllerNombre.text,
        "ci": controllerCI.text,
        "licencia": controllerLicencia.text,
        "phone": controllerPhone.text,
        "email": controllerMail.text
      };
      bodyData.removeWhere((key, value) {
        if (key == 'email' || key == 'licencia') {
          return false;
        } else if (value == '' || value == null) {
          return true;
        }
        return false;
      });

      List<Map> fotos = HttpUploadService.generarListFotos(
          foto: foto,
          ciFront: ciFront,
          ciBack: ciBack,
          licFront: licFront,
          licBack: licBack);
      final response = await UserUtils.updateUserInfo(bodyData);

      if (fotos.isNotEmpty) {
        final errorFotos = await UserUtils.subirFotos(fotos);

        if (errorFotos.isNotEmpty) {
          String errorCode = 'Ocurrió un error al subir las siguientes fotos:';
          for (var element in errorFotos) {
            if (element == 'ci_front') {
              errorCode = errorCode += "\n•Carnet de identidad (frente)";
            }
            if (element == 'ci_back') {
              errorCode = errorCode += "\n•Carnet de identidad (atrás)";
            }
            if (element == 'lic_front') {
              errorCode = errorCode += "\n•Licencia de conducción (frente)";
            }
            if (element == 'lic_back') {
              errorCode = errorCode += "\n•Licencia de conducción (atrás)";
            }
          }
          errorCode += "\nPor favor, reintente otra vez";
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(errorCode)));
          setState(() {
            loading = false;
          });
          return;
        }
      }
      if (response['user'] != null) {
        showSaveButton = false;
        salvadoConExito = true;

        Provider.of<OwnerProvider>(context, listen: false).owner =
            response['user'];
        setState(() {
          loading = false;
        });
        Message.showSnackBarCustom(
            context: context,
            error: false,
            sms: 'Usuario actualizado con éxito');
      } else {
        setState(() {
          loading = false;
        });
        Message.showSnackBarCustom(
            context: context, error: true, sms: response['error']);
      }
    } catch (e) {
      Message.showSnackBarCustom(
          context: context, error: true, sms: e.toString());
      setState(() {
        loading = false;
      });
    }
  }
}

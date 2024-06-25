import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:truck_reservas/models/user_model.dart';
import 'package:truck_reservas/utils/app_url.dart';
import 'package:truck_reservas/utils/owner_token.dart';
import 'package:truck_reservas/utils/user_utils.dart';
import 'package:truck_reservas/utils/validators.dart';
import 'package:truck_reservas/widgets/mensajes.dart';

import '../providers/user_provider.dart';

class RellenarDatosIntroPage extends StatefulWidget {
  RellenarDatosIntroPage({Key? key}) : super(key: key);

  @override
  State<RellenarDatosIntroPage> createState() => _RellenarDatosIntroPageState();
}

class _RellenarDatosIntroPageState extends State<RellenarDatosIntroPage> {
  String? userName;
  bool loading = false;
  final ImagePicker _picker = ImagePicker();
  CroppedFile? croppedFile;
  XFile? foto, ciFront, ciBack, licFront, licBack;
  String? fotoURL, ciFrontURL, ciBackURL, licFrontURL, licBackURL;
  final _introKey = GlobalKey<IntroductionScreenState>();
  TextEditingController controllerNombre = TextEditingController();
  TextEditingController controllerCI = TextEditingController();
  TextEditingController controllerLicencia = TextEditingController();
  TextEditingController controllerPhone = TextEditingController();
  final _formKey1 = GlobalKey<FormState>();
  TextEditingController controllerMail = TextEditingController();
  bool? owner;
  int pagina = 0;

  @override
  void initState() {
    Owner ownerUser = Provider.of<OwnerProvider>(context, listen: false).owner;
    userName = ownerUser.userName ?? '';
    controllerNombre.text = ownerUser.name ?? '';
    controllerCI.text = ownerUser.ci ?? '';
    controllerLicencia.text = ownerUser.licencia ?? '';
    controllerPhone.text = ownerUser.phone ?? '';
    controllerMail.text = ownerUser.email ?? '';
    fotoURL = ownerUser.avatar;
    ciFrontURL = ownerUser.fotoCiFront;
    ciBackURL = ownerUser.fotoCiBack;
    licFrontURL = ownerUser.fotoLicFront;
    licBackURL = ownerUser.fotoLicBack;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [body(), loadingContainer()],
      ),
    );
  }

  Widget body() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
        Color.fromRGBO(36, 16, 65, 1),
        Color.fromRGBO(46, 18, 71, 1),
        Color.fromRGBO(56, 1, 58, 1),
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: IntroductionScreen(
        key: _introKey,
        globalBackgroundColor: Colors.transparent,
        controlsPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        rawPages: [
          pagina1(),
          pagina2(),
          pagina3(),
          pagina4(),
          pagina5(),
          pagina6()
        ],
        showSkipButton: pagina > 0 ? false : true,
        showBackButton: pagina > 0 ? true : false,
        showNextButton: showNextButton(),
        freeze: true, //CAMBIAR A TRUE DESPUES
        back: const Text(
          "Atrás",
          style: TextStyle(color: Color.fromRGBO(36, 16, 65, 1)),
        ),
        next: const Text(
          "Siguiente",
          style: TextStyle(color: Color.fromRGBO(36, 16, 65, 1)),
        ),
        done: const Text(
          "Terminar",
          style: TextStyle(color: Color.fromRGBO(36, 16, 65, 1)),
        ),
        skip: const Text(
          "Salir",
          style: TextStyle(color: Color.fromRGBO(36, 16, 65, 1)),
        ),
        onSkip: () {
          OwnerToken.delete();
          Navigator.pushReplacementNamed(context, 'loginPage');
        },
        onDone: () {
          subirCambios();
        },
        onChange: (value) {
          pagina = value;
          setState(() {});
        },
        dotsContainerDecorator: BoxDecoration(color: Colors.white60),
        dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          activeColor: const Color.fromRGBO(36, 16, 65, 1),
          color: Colors.black26,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        ),
      ),
    );
  }

  Widget pagina1() {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height * 0.2,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: FadeInLeft(
                      child: Text(
                        'Bienvenido,',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize:
                                (MediaQuery.of(context).size.height * 0.15),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  FadeInLeft(
                    child: Text(
                      userName.toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            SpinPerfect(
              duration: const Duration(milliseconds: 500),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                height: MediaQuery.of(context).size.height * 0.30,
                width: double.infinity,
                child: Center(
                  child: Image.asset(
                    'assets/hola_icon.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                  top: 30, left: 10, right: 10, bottom: 10),
              height: MediaQuery.of(context).size.height * 0.25,
              width: double.infinity,
              child: FadeInRight(
                child: const Text(
                  'Antes de usar nuestra app requerimos algunos datos, cuando estés listo toca el botón comenzar ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                  onPressed: () {
                    _introKey.currentState?.next();
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromRGBO(16, 30, 65, 1)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: const BorderSide(
                                  color: Color.fromRGBO(43, 87, 236, 1))))),
                  child: const Text(
                    'Comenzar',
                    style: TextStyle(color: Color.fromRGBO(43, 87, 236, 1)),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget pagina2() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Pregunta...',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            ZoomIn(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.25,
                padding: const EdgeInsets.all(20),
                child: Image.asset('assets/interrogation-mark.png'),
              ),
            ),
            const Text(
              'Eres chofer o propietario del (los) vehículos',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Si eres propietario y chofer a la vez toca la opción (propietario)',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AnimatedScale(
                  duration: const Duration(milliseconds: 150),
                  scale: owner == false ? 1.1 : 1,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          owner = false;
                          setState(() {});
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          height: MediaQuery.of(context).size.width * 0.4,
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: owner == false
                                  ? Colors.grey[400]
                                  : Colors.white,
                              border: Border.all(
                                  width: 4.0,
                                  color: owner == false
                                      ? Colors.blue
                                      : Colors.transparent)),
                          child: Image.asset(
                            'assets/driver.png',
                            height: MediaQuery.of(context).size.height * 0.3,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const Text(
                        'Chofer',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                AnimatedScale(
                  duration: const Duration(milliseconds: 150),
                  scale: owner == true ? 1.1 : 1,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          owner = true;
                          setState(() {});
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          height: MediaQuery.of(context).size.width * 0.4,
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: owner == true
                                  ? Colors.grey[400]
                                  : Colors.white,
                              border: Border.all(
                                  width: 4.0,
                                  color: owner == true
                                      ? Colors.blue
                                      : Colors.transparent)),
                          child: Image.asset(
                            'assets/man.png',
                            height: MediaQuery.of(context).size.height * 0.3,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const Text(
                        'Propietario',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'NOTA: Los propietarios pueden añadir varios camiones, y no requieren ingresar una licencia de conducción. Los choferes si requieren agregar la licencia de conducción y solo pueden añadir un camión',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget pagina3() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
        child: SafeArea(
          child: Form(
            key: _formKey1,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Stack(children: [
                  croppedFile == null
                      ? fotoURL != null
                          ? FutureBuilder(
                              future: OwnerToken.load(),
                              builder: (context, AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  return CircleAvatar(
                                      // backgroundColor: Color(0xff00A3FF),
                                      radius: 80.0,
                                      // backgroundColor: Color(0xff00A3FF),
                                      backgroundImage: NetworkImage(fotoURL!,
                                          headers: {"x-token": snapshot.data}));
                                }
                                return const CircleAvatar(
                                    // backgroundColor: Color(0xff00A3FF),
                                    radius: 80.0,
                                    backgroundColor: Colors.grey,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ));
                              })
                          : const CircleAvatar(
                              // backgroundColor: Color(0xff00A3FF),
                              radius: 80.0,
                              // backgroundColor: Color(0xff00A3FF),
                              backgroundImage: AssetImage('assets/picture.png'))
                      : CircleAvatar(
                          // backgroundColor: Color(0xff00A3FF),
                          radius: 80.0,
                          // backgroundColor: Color(0xff00A3FF),
                          backgroundImage: FileImage(File(croppedFile!.path))),
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
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Añade una foto (opcional)',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 30,
                ),
                textfieldCreator(
                    controllerNombre,
                    'Nombre y apellidos',
                    false,
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
                    'CI',
                    false,
                    const Icon(
                      Icons.list_alt_sharp,
                      color: Colors.white,
                    ),
                    'CI'),
                // const SizedBox(
                //   height: 5,
                // ),
                textfieldCreator(
                    controllerLicencia,
                    'Licencia de conducción*',
                    false,
                    const Icon(
                      Icons.directions_car,
                      color: Colors.white,
                    ),
                    'licencia'),
                const Text(
                  '* Opcional si eres propietario del vehículo',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget pagina4() {
    return SingleChildScrollView(
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                    child: FadeInLeft(
                      child: const Text(
                        'Necesitamos fotos de tus documentos para verificar tu perfil',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  ZoomIn(
                    child: Image.asset(
                      'assets/drivers-license.png',
                      height: 100,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              FadeInLeft(
                child: const Text(
                  '*No compartimos esta información con terceros',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Carnet de identidad:',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ZoomIn(
                    duration: const Duration(milliseconds: 100),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            imageSourcePicker(true, 'ci_front');
                          },
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.width * 0.3,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(20)),
                              child: ciFront == null
                                  ? ciFrontURL != null
                                      //la logica es: si hay foto desde el backend muestrala
                                      // a menos q el user la updatee, en ese caso
                                      //muestra la local, si no hay ninguna muestra
                                      //el container
                                      ? containerFotoNetwork(ciFrontURL)
                                      : containerNofoto()
                                  : containerFotoFIle(
                                      ciFront!.path, 'ci_front')),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Frente',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  ZoomIn(
                    duration: const Duration(milliseconds: 200),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            imageSourcePicker(true, 'ci_back');
                          },
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.width * 0.3,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(20)),
                              child: ciBack == null
                                  ? ciBackURL != null
                                      ? containerFotoNetwork(ciBackURL)
                                      : containerNofoto()
                                  : containerFotoFIle(ciBack!.path, 'ci_back')),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Atrás',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Licencia de conducción:',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                '*opcional si es propietario',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ZoomIn(
                    duration: const Duration(milliseconds: 300),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            imageSourcePicker(true, 'lic_front');
                          },
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.width * 0.3,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(20)),
                              child: licFront == null
                                  ? licFrontURL != null
                                      ? containerFotoNetwork(licFrontURL)
                                      : containerNofoto()
                                  : containerFotoFIle(
                                      licFront!.path, 'lic_front')),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Frente',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  ZoomIn(
                    duration: const Duration(milliseconds: 400),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            imageSourcePicker(true, 'lic_back');
                          },
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.width * 0.3,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(20)),
                              child: licBack == null
                                  ? licBackURL != null
                                      ? containerFotoNetwork(licBackURL)
                                      : containerNofoto()
                                  : containerFotoFIle(
                                      licBack!.path, 'lic_back')),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Atrás',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget pagina5() {
    return SafeArea(
        child: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            FadeInDown(
              child: const Text(
                'Ya casi estamos listos.',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
            ZoomIn(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.25,
                padding: const EdgeInsets.all(20),
                child: Image.asset('assets/phone_ico.png'),
              ),
            ),
            FadeInRight(
              child: const Text(
                'Una última pregunta..',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            textfieldCreator(
                controllerPhone,
                'Número de teléfono',
                false,
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
                false,
                const Icon(
                  Icons.mail,
                  color: Colors.white,
                ),
                'mail'),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                '* El correo es opcional. pero te recomendamos agragar uno ya que es necesario a la hora de recuperar una contraseña olvidada :)',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget pagina6() {
    return SafeArea(
        child: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height * 0.3,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: FadeInLeft(
                    child: Text(
                      'Felicidades',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: (MediaQuery.of(context).size.height * 0.15),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                FadeInLeft(
                  child: const Text(
                    'Has completado el registro exitosamente',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Swing(
            duration: const Duration(seconds: 7),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              height: MediaQuery.of(context).size.height * 0.30,
              width: double.infinity,
              child: Center(
                child: Image.asset(
                  'assets/confetti.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            padding:
                const EdgeInsets.only(top: 30, left: 10, right: 10, bottom: 10),
            height: MediaQuery.of(context).size.height * 0.25,
            width: double.infinity,
            child: FadeInRight(
              child: const Text(
                'Ya puedes empezar a usar <APP NAME>. Pulsa el botón terminar para guardar los cambios y salir.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget textfieldCreator(TextEditingController controller, String labelText,
      bool isForPassword, Icon icon, String tipo) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
            child: Text(
              labelText,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: TextFormField(
              onChanged: (value) {
                setState(() {});
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              maxLength: tipo == 'CI' || tipo == 'licencia'
                  ? 11
                  : tipo == 'phone'
                      ? 8
                      : null,
              controller: controller,
              keyboardType:
                  tipo == 'CI' || tipo == 'licencia' || tipo == 'phone'
                      ? TextInputType.number
                      : tipo == 'mail'
                          ? TextInputType.emailAddress
                          : null,
              inputFormatters: tipo == 'CI' ||
                      tipo == 'licencia' ||
                      tipo == 'phone'
                  ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
                  : null, // Only numbers can be entered
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  errorText: null,
                  prefixIcon: icon,
                  filled: true,
                  fillColor: const Color.fromRGBO(31, 46, 75, 1),
                  counterStyle: const TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  bool showNextButton() {
    if (pagina == 0) {
      return false;
    } else if (pagina == 1 && owner == null) {
      return false;
    } else if (pagina == 2) {
      if (controllerNombre.text == '' || controllerCI.text == '') {
        return false;
      }
      if (Validators.validarCI(controllerCI.text) != null) {
        return false;
      }
      if (owner == false &&
          Validators.validarCI(controllerLicencia.text) != null) {
        return false;
      }
      return true;
    } else if (pagina == 3) {
      if ((ciBack == null && ciBackURL == null) ||
          (ciFront == null && ciFrontURL == null)) {
        return false;
      }
      if (owner == false &&
          ((licBack == null && licBackURL == null) ||
              (licFront == null && licFrontURL == null))) {
        return false;
      }
      if (owner == true &&
          ((licBack != null || licBackURL != null) &&
              (licFront == null && licFrontURL == null))) {
        return false;
      }
      if (owner == true &&
          ((licBack != null || licBackURL != null) &&
              (licFront == null && licFrontURL == null))) {
        return false;
      }
      return true;
    } else if (pagina == 4) {
      if (Validators.validarPhone(controllerPhone.text) != null) {
        return false;
      }
      if (controllerMail.text.isNotEmpty) {
        if (Validators.validarEmail(controllerMail.text) != null) {
          return false;
        }
      }
      return true;
    } else {
      return true;
    }
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

  Widget containerNofoto() {
    return const Center(
        child: Text(
      'Toca para añadir una foto',
      style: TextStyle(
          color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
    ));
  }

  Widget containerFotoFIle(String? path, String fotoAborrar) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.width * 0.3,
          width: MediaQuery.of(context).size.width * 0.4,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                File(path!),
                fit: BoxFit.cover,
              )),
        ),
        Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              onPressed: () {
                deleteFoto(fotoAborrar);
              },
              icon: const CircleAvatar(
                child: Icon(Icons.delete),
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
            return ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CachedNetworkImage(
                httpHeaders: {"x-token": snapshot.data},
                fit: BoxFit.cover,
                imageUrl: url!,
                placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(
                  color: Colors.white,
                )),
                errorWidget: (context, url, error) =>
                    const Center(child: Icon(Icons.error)),
              ),
            );
          }
          return SizedBox(
            height: MediaQuery.of(context).size.width * 0.3,
            width: MediaQuery.of(context).size.width * 0.4,
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

  void subirCambios() async {
    try {
      setState(() {
        loading = true;
      });
      final Map body = {
        "owner": owner,
        "Nombre_Ap": controllerNombre.text,
        "ci": controllerCI.text,
        "licencia":
            controllerLicencia.text.isEmpty ? null : controllerLicencia.text,
        "phone": controllerPhone.text,
        "email": controllerMail.text.isEmpty ? null : controllerMail.text
      };

      List<Map> listaFotos = [];
      if (foto != null) {
        listaFotos.add(
            {"path": foto!.path, "ruta": AppUrl.fotoAvatar, "tipo": "avatar"});
      }
      if (ciFront != null) {
        listaFotos.add({
          "path": ciFront!.path,
          "ruta": AppUrl.fotoCiFront,
          "tipo": "ci_front"
        });
      }
      if (ciBack != null) {
        listaFotos.add({
          "path": ciBack!.path,
          "ruta": AppUrl.fotoCiBack,
          "tipo": "ci_back"
        });
      }
      if (licFront != null) {
        listaFotos.add({
          "path": licFront!.path,
          "ruta": AppUrl.fotoLicFront,
          "tipo": "lic_front"
        });
      }
      if (licBack != null) {
        listaFotos.add({
          "path": licBack!.path,
          "ruta": AppUrl.fotoLicBack,
          "tipo": "lic_back"
        });
      }

      final response = await UserUtils.updateUserInfo(body);

      if (listaFotos.isNotEmpty) {
        final errorFotos = await UserUtils.subirFotos(listaFotos);

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
        setState(() {
          loading = false;
        });
        Navigator.pushReplacementNamed(context, 'homePage');
      } else {
        setState(() {
          loading = false;
        });
        Message.showSnackBarCustom(
            context: context, error: true, sms: response['error']);
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }
}

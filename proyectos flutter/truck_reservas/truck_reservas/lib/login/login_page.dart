// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:truck_reservas/utils/owner_token.dart';
import 'package:truck_reservas/utils/user_utils.dart';
import 'package:truck_reservas/utils/validators.dart';
import 'package:truck_reservas/widgets/mensajes.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loading = false;
  String? tipoDePantalla;
  bool showPassword = false;
  double sizeOffsetContainer1 = 0;
  double sizeOffsetContainer2 = 0;
  double sizeOffsetContainer3 = 0;
  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController repeatPassController = TextEditingController();
  String? errorTextUser;
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   sizeOffsetContainer1 = -(MediaQuery.of(context).size.height * 0.35);
  //   sizeOffsetContainer2 = -(MediaQuery.of(context).size.height * 0.35) + 100;
  //   sizeOffsetContainer3 = -(MediaQuery.of(context).size.height * 0.35) + 200;
  //   super.didChangeDependencies();
  // }

  @override
  void dispose() {
    super.dispose();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values); // to re-show bars
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(context),
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
    );
  }

  Widget body(BuildContext context) {
    return Stack(
      children: [
        AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            bottom: sizeOffsetContainer3 != 0
                ? sizeOffsetContainer3
                : sizeOffsetContainer3 =
                    -(MediaQuery.of(context).size.height * 0.35) + 200,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.65,
              width: MediaQuery.of(context).size.width,
              child: CustomPaint(
                  painter: CurvePainter(
                      const Color.fromRGBO(242, 243, 247, 1), false)),
            )),
        AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            bottom: sizeOffsetContainer2 != 0
                ? sizeOffsetContainer2
                : sizeOffsetContainer2 =
                    -(MediaQuery.of(context).size.height * 0.35) + 100,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.65,
              width: MediaQuery.of(context).size.width,
              child: CustomPaint(
                  painter: CurvePainter(
                      const Color.fromRGBO(232, 233, 237, 1), false)),
            )),
        icono(),
        botonAtras(),
        AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            bottom: sizeOffsetContainer1 != 0
                ? sizeOffsetContainer1
                : sizeOffsetContainer1 =
                    -(MediaQuery.of(context).size.height * 0.35),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.65,
              width: MediaQuery.of(context).size.width,
              child: CustomPaint(
                painter:
                    CurvePainter(const Color.fromRGBO(16, 30, 65, 1), true),
                child: tipoDePantalla == null
                    ? const SizedBox()
                    : tipoDePantalla == 'Login'
                        ? formularioLogin()
                        : formularioRegistro(),
              ),
            )),
        botones(),
        loadingContainer()
      ],
    );
  }

  Widget botones() {
    if (tipoDePantalla != null) {
      return const SizedBox();
    }
    return Positioned(
      bottom: 0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.25,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              child: ElevatedButton(
                  onPressed: () {
                    tipoDePantalla = 'Login';
                    sizeOffsetContainer1 =
                        -(MediaQuery.of(context).size.height * 0.15);
                    sizeOffsetContainer2 =
                        -(MediaQuery.of(context).size.height * 0.15) + 60;
                    sizeOffsetContainer3 =
                        -(MediaQuery.of(context).size.height * 0.15) + 120;

                    setState(() {});
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromRGBO(43, 87, 236, 1)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ))),
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
                  )),
            ),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                  onPressed: () {
                    tipoDePantalla = 'Registro';
                    sizeOffsetContainer1 = -1;
                    sizeOffsetContainer2 = -1;
                    sizeOffsetContainer3 = -1;
                    setState(() {});
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
                    'Registro',
                    style: TextStyle(color: Color.fromRGBO(43, 87, 236, 1)),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget botonAtras() {
    return Stack(
      children: [
        Positioned(
          top: -((MediaQuery.of(context).size.width * 0.7) / 2 + 20),
          left: (-(MediaQuery.of(context).size.width * 0.7) / 2) + 50,
          child: AnimatedOpacity(
            opacity: tipoDePantalla == null ? 0 : 1,
            duration: const Duration(milliseconds: 300),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.width * 0.7,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(50, 85, 237, 1)),
            ),
          ),
        ),
        Positioned(
            top: 0,
            left: 0,
            child: AnimatedOpacity(
              opacity: tipoDePantalla == null ? 0 : 1,
              duration: const Duration(milliseconds: 300),
              child: Container(
                // color: Colors.red.withOpacity(0.3),
                height: (MediaQuery.of(context).size.width * 0.7) / 2 - 20,
                width: ((MediaQuery.of(context).size.width * 0.7) / 2) + 50,
                padding: const EdgeInsets.only(top: 15, left: 15),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          resetValues();
                          tipoDePantalla = null;
                          sizeOffsetContainer1 = 0;
                          sizeOffsetContainer2 = 0;
                          sizeOffsetContainer3 = 0;
                          setState(() {});
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            Text(
                              ' Atrás',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        tipoDePantalla ?? '',
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ))
      ],
    );
  }

  Widget icono() {
    return ZoomIn(
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: tipoDePantalla == null ? 1 : 0,
        child: Center(
          child: Image.asset(
            'assets/icono.png',
            width: MediaQuery.of(context).size.width / 2,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget formularioLogin() {
    return Container(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.15,
          left: 30,
          right: 30,
          top: 20),
      // height: MediaQuery.of(context).size.height * 0.2,
      //width: double.infinity,
      //  color: Colors.red.withOpacity(0.3),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              textfieldCreator(
                  userController,
                  'Usuario',
                  false,
                  const Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  'user'),
              const SizedBox(
                height: 20,
              ),
              textfieldCreator(
                  passController,
                  'Contraseña',
                  true,
                  const Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                  'pass'),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: <TextSpan>[
                    const TextSpan(
                        text: 'Aun no tienes una cuenta? ',
                        style: TextStyle(color: Colors.white)),
                    TextSpan(
                        text: ' Regístrate.',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            resetValues();
                            tipoDePantalla = 'Registro';
                            sizeOffsetContainer1 = -1;
                            sizeOffsetContainer2 = -1;
                            sizeOffsetContainer3 = -1;
                            setState(() {});
                          }),
                  ]),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              loginButon()
            ],
          ),
        ),
      ),
    );
  }

  Widget formularioRegistro() {
    return Container(
      padding: const EdgeInsets.only(
          // bottom: MediaQuery.of(context).size.height * 0.15,
          left: 30,
          right: 30,
          top: 20),
      // height: MediaQuery.of(context).size.height * 0.2,
      //width: double.infinity,
      //  color: Colors.red.withOpacity(0.3),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _formKey2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              textfieldCreator(
                  userController,
                  'Usuario',
                  false,
                  const Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  'user'),
              const SizedBox(
                height: 20,
              ),
              textfieldCreator(
                  passController,
                  'Contraseña',
                  true,
                  const Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                  'pass'),
              const SizedBox(
                height: 5,
              ),
              const Text(
                'La contraseña debe contener al menos 8 caracteres, letras mayúsculas, minúsculas, números y algún símbolo especial (ej: #\$@!*)',
                style: TextStyle(fontSize: 10, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              textfieldCreator(
                  repeatPassController,
                  'Repetir contraseña',
                  true,
                  const Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                  'RepeatPass'),
              const SizedBox(
                height: 20,
              ),
              registroBoton()
            ],
          ),
        ),
      ),
    );
  }

  Widget textfieldCreator(TextEditingController controller, String labelText,
      bool isForPassword, Icon icon, String tipo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            labelText,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        TextFormField(
          validator: (value) {
            if (value == null || value == '') {
              return 'Rellena este campo';
            } else if (tipo == 'user') {
              return Validators.validarUser(value);
            } else if (tipo == 'pass') {
              return Validators.validarPassword(value);
            } else if (tipo == 'RepeatPass') {
              return Validators.validarPasswordRepetido(
                  value, passController.text);
            }
            return null;
          },
          controller: controller,
          obscureText: isForPassword == true
              ? showPassword == false
                  ? true
                  : false
              : false,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
              suffixIcon: isForPassword
                  ? IconButton(
                      icon: const Icon(Icons.remove_red_eye),
                      color: showPassword ? Colors.blue : Colors.white,
                      onPressed: () {
                        showPassword = !showPassword;
                        setState(() {});
                      },
                    )
                  : null,
              errorText: null,
              prefixIcon: icon,
              filled: true,
              fillColor: const Color.fromRGBO(31, 46, 75, 1)),
        ),
      ],
    );
  }

  Widget loginButon() {
    return Center(
      child: SizedBox(
        width: 100,
        child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // If the form is valid, display a snackbar. In the real world,
                // you'd often call a server or save the information in a database.
                loginAndRegister(true);
              }
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromRGBO(43, 87, 236, 1)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ))),
            child: const Text(
              'Login',
              style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
            )),
      ),
    );
  }

  Widget registroBoton() {
    return Center(
      child: SizedBox(
        width: 100,
        child: ElevatedButton(
            onPressed: () {
              if (_formKey2.currentState!.validate()) {
                // If the form is valid, display a snackbar. In the real world,
                // you'd often call a server or save the information in a database.

                loginAndRegister(false);
              }
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
              'Registrate',
              style: TextStyle(color: Color.fromRGBO(43, 87, 236, 1)),
            )),
      ),
    );
  }

  void resetValues() {
    showPassword = false;
    userController = TextEditingController();
    passController = TextEditingController();
    repeatPassController = TextEditingController();
    setState(() {});
  }

  void loginAndRegister(bool login) async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      loading = true;
    });
    try {
      final response = await UserUtils.loginAndRegister(
          userController.text, passController.text, login);
      if (response['user'] == null) {
        Message.showSnackBarCustom(
            context: context, sms: response['error'], error: true);
        setState(() {
          loading = false;
        });
        return;
      }
      Owner owner = response['user'];
      Provider.of<OwnerProvider>(context, listen: false).owner = owner;

      setState(() {
        loading = false;
      });
      if (!login) {
        Navigator.pushReplacementNamed(context, 'rellenarDatos');
        return;
      }

      if (Validators.userShouldCompleteInfo(owner)) {
        Navigator.pushReplacementNamed(context, 'rellenarDatos');
      } else {
        Navigator.pushReplacementNamed(context, 'homePage');
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      Message.showSnackBarCustom(
          context: context, sms: e.toString(), error: true);
    }
  }

  Widget loadingContainer() {
    if (!loading) {
      return const SizedBox();
    }
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: SpinKitThreeBounce(
            color: Colors.indigo[800],
            size: 35.0,
          ),
        ),
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  final Color color;
  final bool hacerGradient;
  CurvePainter(this.color, this.hacerGradient);
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    var paint = Paint();
    LinearGradient gradient = const LinearGradient(colors: [
      Color.fromRGBO(36, 16, 65, 1),
      Color.fromRGBO(46, 18, 71, 1),
      Color.fromRGBO(56, 1, 58, 1),
    ], begin: Alignment.topCenter, end: Alignment.bottomCenter);
    if (hacerGradient) {
      paint.shader =
          gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    } else {
      paint.color = color;
      paint.style = PaintingStyle.fill;
    }

    var path = Path();

    path.moveTo(0, 0);
    path.quadraticBezierTo(size.width / 2, -100, size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

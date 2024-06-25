import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:truck_reservas/2fa/totp_generator.dart';
import 'package:truck_reservas/login/login_page.dart';
import 'package:truck_reservas/pages/agregar_camion_page.dart';
import 'package:truck_reservas/pages/home_page.dart';
import 'package:truck_reservas/pages/loading_page.dart';
import 'package:truck_reservas/pages/rellenar_datos_intro_page.dart';
import 'package:truck_reservas/pages/user_page.dart';
import 'package:truck_reservas/providers/user_provider.dart';

void main() async {
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OwnerProvider()),
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blue,
          ),
          home: MyHomePage(),
          routes: {
            'loginPage': (context) => LoginPage(),
            'rellenarDatos': (context) => RellenarDatosIntroPage(),
            'agregarCamion': (context) => AgregarCamion(),
            'homePage': (context) => HomePage(),
            'userPage': (context) => UserPage(),
          }),
    );
  }
}

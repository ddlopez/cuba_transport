import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:truck_reservas/login/login_page.dart';
import 'package:truck_reservas/pages/home_page.dart';
import 'package:truck_reservas/pages/rellenar_datos_intro_page.dart';
import 'package:truck_reservas/utils/owner_token.dart';
import 'package:truck_reservas/utils/user_utils.dart';
import 'package:truck_reservas/utils/validators.dart';

import '../models/user_model.dart';
import '../providers/user_provider.dart';

class LoadingPage extends StatefulWidget {
  LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: obtenerToken(),
    );
  }

  Widget obtenerToken() {
    return FutureBuilder(
        future: OwnerToken.load(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == 'NO_TOKEN') {
              //SI no hay token ve pal login
              return LoginPage();
            }
            return obtenerUserInfo(); // si hay carga data del user
          }
          return Center(
            child: SpinKitThreeBounce(
              color: Colors.indigo[800],
              size: 35.0,
            ),
          );
        });
  }

  Widget obtenerUserInfo() {
    return FutureBuilder(
        future: UserUtils.getUserInfo(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SpinKitThreeBounce(
                color: Colors.indigo[800],
                size: 35.0,
              ),
            );
          }

          if (snapshot.hasData) {
            //tiene data

            if (snapshot.data['user'] != null) {
              return Validators.userShouldCompleteInfo(snapshot.data['user']) ==
                      true
                  ? RellenarDatosIntroPage() //si al user le faltan campos ve a completarlos
                  : HomePage(); // si todo esta OK ve pal homePage
            } else {
              return errorPage(snapshot.data['error']);
            }
          }
          return Center(
            child: SpinKitThreeBounce(
              color: Colors.indigo[800],
              size: 35.0,
            ),
          );
        });
  }

  Widget errorPage(String? error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/error_icon.png',
            height: 200,
            fit: BoxFit.cover,
          ),
          const SizedBox(
            height: 8,
          ),
          const Text(
            'Ha ocurrido un error',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              error ?? '',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          ElevatedButton(
              onPressed: () {
                setState(() {});
              },
              child: const Text('Reintentar')),
          const SizedBox(
            height: 5,
          ),
          TextButton(
            onPressed: () {
              OwnerToken.delete();
              Navigator.pushReplacementNamed(context, 'loginPage');
            },
            child: const Text('Iniciar sesión de nuevo',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}

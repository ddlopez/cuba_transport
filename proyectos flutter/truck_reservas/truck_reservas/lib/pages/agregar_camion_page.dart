import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class AgregarCamion extends StatefulWidget {
  AgregarCamion({Key? key}) : super(key: key);

  @override
  State<AgregarCamion> createState() => _AgregarCamionState();
}

class _AgregarCamionState extends State<AgregarCamion> {
  final ImagePicker _picker = ImagePicker();
  TextEditingController nombreController = TextEditingController();
  TextEditingController chapaController = TextEditingController();
  TextEditingController circulacionController = TextEditingController();
  TextEditingController capacidad = TextEditingController();

  XFile? foto;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(),
    );
  }

  Widget body() {
    return Container(
      //  padding: const EdgeInsets.all(10),
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
        Color.fromRGBO(36, 16, 65, 1),
        Color.fromRGBO(46, 18, 71, 1),
        Color.fromRGBO(56, 1, 58, 1),
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: SafeArea(
          child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _crearAppbar(context),
          SliverList(
              delegate: SliverChildListDelegate([
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ElevatedButton(
                  onPressed: () {
                    imageSourcePicker();
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromRGBO(16, 30, 65, 1)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: const BorderSide(
                                  color: Color.fromRGBO(43, 87, 236, 1))))),
                  child: Text(
                    foto == null
                        ? 'Agrega una foto de tu vehículo'
                        : 'Cambiar foto ',
                    style:
                        const TextStyle(color: Color.fromRGBO(43, 87, 236, 1)),
                  )),
            ),
            nombre(),
            modeloYcapacidad()
          ])),
        ],
      )),
    );
  }

  void imageSourcePicker() {
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
                        pickImage('camara');
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
                        pickImage('galeria');
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
    if (source == 'galeria') {
      foto = await _picker.pickImage(
          source: ImageSource.gallery, imageQuality: 40);
    } else if (source == 'camara') {
      foto =
          await _picker.pickImage(source: ImageSource.camera, imageQuality: 40);
    }

    if (foto == null) {
      return;
    }

    setState(() {});
  }

  Widget nombre() {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
                child: Container(
              height: 1,
              color: Colors.white,
            )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/chapa.png',
                height: 54,
              ),
            ),
            Expanded(
                child: Container(
              height: 1,
              color: Colors.white,
            )),
          ],
        ),
        textfieldCreator(
            nombreController,
            'Nombre del vehículo',
            const Icon(
              Icons.directions_bus,
              color: Colors.white,
            ),
            'name'),
        const SizedBox(
          height: 20,
        ),
        textfieldCreator(
            nombreController,
            'Chapa',
            const Icon(
              Icons.numbers,
              color: Colors.white,
            ),
            'chapa'),
        textfieldCreator(
            nombreController,
            'Circulación',
            const Icon(
              Icons.list_alt_outlined,
              color: Colors.white,
            ),
            'circulacion'),
      ],
    );
  }

  Widget modeloYcapacidad() {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
                child: Container(
              height: 1.0,
              color: Colors.white,
            )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/formulario-de-contacto.png',
                height: 54,
              ),
            ),
            Expanded(
                child: Container(
              height: 1.0,
              color: Colors.white,
            )),
          ],
        ),
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
              autovalidateMode: AutovalidateMode.onUserInteraction,
              maxLength: tipo == 'chapa' || tipo == 'circulacion' ? 7 : null,
              controller: controller,
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

  _crearAppbar(BuildContext context) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.blue.withOpacity(0.3),
      expandedHeight: 200.0,
      floating: false,
      pinned: false,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        //  title: Text('Manual VAZ 2107', style: TextStyle(color: Colors.grey[800]),),
        background: foto == null
            ? Center(
                child: Image.asset(
                'assets/bus.png',
                height: 150,
                fit: BoxFit.cover,
              ))
            : Image.file(
                File(foto!.path),
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height * 0.3,
                width: double.infinity,
              ),
      ),
    );
  }
}

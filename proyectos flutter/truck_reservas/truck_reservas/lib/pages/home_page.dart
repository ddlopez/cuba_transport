import 'package:flutter/material.dart';
import 'package:truck_reservas/providers/user_provider.dart';
import 'package:truck_reservas/utils/owner_token.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 3, vsync: this);
    PageController pageController = PageController();

    return Scaffold(
        drawer: drawerCreator(context),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "APP sin nombre",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
              gradient: LinearGradient(colors: [
                Color.fromRGBO(36, 16, 65, 1),
                Color.fromRGBO(46, 18, 71, 1),
                Color.fromRGBO(56, 1, 58, 1),
              ], begin: Alignment.topLeft, end: Alignment.bottomRight),
            ),
          ),
          bottom: TabBar(
            indicatorPadding: const EdgeInsets.symmetric(horizontal: 10),
            indicatorSize: TabBarIndicatorSize.label,
            controller: tabController,
            tabs: const [
              Tab(
                icon: Icon(Icons.directions),
                text: "Mis viajes",
              ),
              Tab(
                icon: Icon(Icons.directions_bus),
                text: "Vehículos",
              ),
              Tab(icon: Icon(Icons.check_circle_sharp), text: "Reservaciones"),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: const [
            Center(child: Text('viajes')),
            Center(child: Text('vehiculos')),
            Center(child: Text('reseervas'))
          ],
        ));
  }

  drawerCreator(BuildContext context) {
    String username =
        Provider.of<OwnerProvider>(context, listen: false).owner.userName ?? '';
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(36, 16, 65, 1),
                  Color.fromRGBO(46, 18, 71, 1),
                  Color.fromRGBO(56, 1, 58, 1),
                ], begin: Alignment.topLeft, end: Alignment.bottomRight),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: fotoUser()),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    username,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )
                ],
              )),
          ListTile(
              leading: const Icon(
                Icons.person,
                color: Color.fromRGBO(56, 1, 58, 1),
              ),
              title: const Text('Mi cuenta'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, 'userPage');
              }),
          ListTile(
              leading: const Icon(
                Icons.logout,
                color: Color.fromRGBO(56, 1, 58, 1),
              ),
              title: const Text('Cerrar sesión'),
              onTap: () async {
                Navigator.pop(context);
                await OwnerToken.delete();
                Navigator.pushReplacementNamed(context, 'loginPage');
              }),
        ],
      ),
    );
  }

  Widget fotoUser() {
    String? urlFoto =
        Provider.of<OwnerProvider>(context, listen: false).owner.avatar;
    if (urlFoto == null) {
      return const CircleAvatar(
        radius: 50,
        backgroundImage: AssetImage('assets/man.png'),
        backgroundColor: Colors.white,
      );
    }
    return FutureBuilder(
        future: OwnerToken.load(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return CircleAvatar(
                // backgroundColor: Color(0xff00A3FF),
                radius: 50.0,
                // backgroundColor: Color(0xff00A3FF),
                backgroundImage:
                    NetworkImage(urlFoto, headers: {"x-token": snapshot.data}));
          }
          return const CircleAvatar(
              // backgroundColor: Color(0xff00A3FF),
              radius: 50.0,
              backgroundColor: Colors.transparent,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ));
        });
  }
}

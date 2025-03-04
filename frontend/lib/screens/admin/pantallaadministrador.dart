import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/commons/custombutton.dart';
import 'package:frontend_flutter/screens/admin/pantallagestionpedidos.dart';
import 'package:frontend_flutter/screens/admin/pantallagestionproductos.dart';
import 'package:frontend_flutter/screens/admin/pantallagestionusuarios.dart';
import 'package:frontend_flutter/screens/usuario/pantallaperfil.dart';
import 'package:frontend_flutter/screens/login/pantallaprincipal.dart';
import 'package:frontend_flutter/widgets/drawer.dart';
import '../../data/models/user.dart';

class MyAdminPage extends StatefulWidget {
  final User usuarioAdmin;

  const MyAdminPage({super.key, required this.usuarioAdmin});

  @override
  _MyAdminPageState createState() => _MyAdminPageState();
}

class _MyAdminPageState extends State<MyAdminPage> {
  void _pantallaInicio() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Pantalla Principal',)),
      (route) => false,
    );
  }

  void _salir() {
    exit(0);
  }

  void _pantallaPerfil() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProfilePage(usuarioActual: widget.usuarioAdmin)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Bienvenido ${widget.usuarioAdmin.nombre}"),
      ),
      drawer: DrawerPrincipal(
        onMiPerfil: _pantallaPerfil,
        onPantallaPrincipal: _pantallaInicio,
        onSalir: _salir,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFE3F2FD)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomEButtonAdmin(
                text: 'Gestión de Usuarios',
                myFunction: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdministerManagementPage(
                              currentAdmin: widget.usuarioAdmin,
                            )),
                  );
                },
                icon: Icons.supervised_user_circle,
              ),
              const SizedBox(height: 40),
              CustomEButtonAdmin(
                text: 'Gestión de Productos',
                myFunction: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyProductPage()),
                  );
                },
                icon: Icons.shopping_bag,
              ),
              const SizedBox(height: 40),
              CustomEButtonAdmin(
                text: 'Gestión de Pedidos',
                myFunction: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyOrdersPage()),
                  );
                },
                icon: Icons.shopping_cart,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

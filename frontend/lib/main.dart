import 'package:flutter/material.dart';
import 'package:frontend_flutter/providers/pedidoprovider.dart';
import 'package:frontend_flutter/providers/usuarioprovider.dart';
import 'package:frontend_flutter/providers/productoprovider.dart';
import 'package:provider/provider.dart';
import 'screens/login/pantallaprincipal.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UsuarioProvider()..fetchUsuarios()
        ),
        ChangeNotifierProvider(
          create: (context) => ProductoProvider()..fetchProductos()
        ),
        ChangeNotifierProvider(
          create: (context) => PedidoProvider()..fetchPedidos()
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Proyecto Final Coldman S.A',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 33, 150, 243)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Pantalla principal'),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:frontend_flutter/providers/usuarioprovider.dart';
import 'package:frontend_flutter/commons/constants.dart';
import 'package:frontend_flutter/commons/custombutton.dart';
//import 'package:frontend_flutter/providers/usuarioprovider.dart';
import 'package:frontend_flutter/screens/admin/pantallaadministrador.dart';
import 'package:frontend_flutter/screens/login/pantallaregistro.dart';
import 'package:frontend_flutter/screens/usuario/pantallainiciocliente.dart';
import 'package:frontend_flutter/data/models/user.dart';
import 'package:frontend_flutter/commons/snacksbar.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  get user => null;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  bool obscureText = true;
  String _nombre = '';
  String _contrasena = '';
  User? user;
  int selectedIndex = 0;
  late final List<Widget> pages;
  var logger = Logger();

  Future<void> _pantallaInicio() async {
    final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
    List<User> listaUsuarios = await usuarioProvider.fetchListaUsuarios();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }

    for (User miUsuario in listaUsuarios) {
      if (miUsuario.getNombre() == _nombre && miUsuario.getPass() == _contrasena) {
        if (miUsuario.getBloqueado()) {
          SnaksBar.showSnackBar(
            context, "Usuario bloqueado, por favor contacta con el administrador", color: Constants.errorColor
          );
          return;
        }
        
        if (miUsuario.getAdministrador() == false) {
          Navigator.push(
            context, MaterialPageRoute(
              builder: (context) => MyStartedPage(user: miUsuario)
            ),
          );
          break;
        } else {
          Navigator.push(
            context, MaterialPageRoute(
              builder: (context) => MyAdminPage(usuarioAdmin: miUsuario)
            ),
          );
        }
      }
    }

    if (_nombre == 'admin' && _contrasena == 'admin') {
      user = User.empty();
      Navigator.push(
        context, MaterialPageRoute(
          builder: (context) => MyAdminPage(usuarioAdmin: user!)
        ),
      );
    } else {
      SnaksBar.showSnackBar(
        context, 'Usuario o Contraseña incorrecta', color: Constants.errorColor
      );
    }
  }

  void openRegister() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const MyRegisterPage()));
  }

  void openStarted() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyStartedPage(user: user!)),
    );
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void openStartedAdmin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyAdminPage(usuarioAdmin: user!)),
    );
  }

  /*void startSession() {
    if (_formKey.currentState!.validate()) {
      String usuario = userController.text;
      String contrasena = passController.text;

      String? mensajeError = Logica.validarUser(usuario, contrasena);
      if (mensajeError != null) {
        SnaksBar.showSnackBar(context, mensajeError,
            color: Constants.errorColor);
        return;
      }

      User? user = Logica.findUser(usuario);
      if (user != null) {
        if (user.administrador) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MyAdminPage(usuarioAdmin:  user)),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyStartedPage(user: user)),
          );
        }
      }
    }
  }*/


  void olvidasteContrasena(BuildContext context) {
    final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
    TextEditingController nombreUsuarioController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Recuperar contraseña"),
        content: TextField(
          controller: nombreUsuarioController,
          decoration: const InputDecoration(labelText: "Usuario"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              String nombre = nombreUsuarioController.text;
              for (User miUsuario in usuarioProvider.usuarios) {
                if (miUsuario.getNombre() == nombre) {
                  String contrasenaUser = miUsuario.getPass();
                  SnaksBar.showSnackBar(
                    context, "La contrasena es: $contrasenaUser", color: Constants.successColor
                  );
                  break; 
                } else {
                  SnaksBar.showSnackBar(
                    context, "Usuario no encontrado", color: Constants.errorColor
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blueAccent,
                textStyle: const TextStyle(fontSize: 15),
              ),
            child: const Text("Enviar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Image.asset(
                  'assets/images/logo_coldman.png',
                  width: 450,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: SizedBox(
                  height: 40,
                  width: 300,
                  child: TextFormField(
                    controller: userController,
                    decoration: InputDecoration(
                      labelText: 'Usuario',
                      border: OutlineInputBorder(),
                      errorStyle: TextStyle(fontSize: 10),
                    ),
                    onSaved: (nombre) {
                      _nombre = nombre!;
                    },
                    validator: (value) =>
                        value!.isEmpty ? 'Enter your username' : null,
                    onTap: () {
                      setState(() {
                        _formKey.currentState!.reset();
                      });
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: SizedBox(
                  height: 40,
                  width: 300,
                  child: TextFormField(
                    controller: passController,
                    obscureText: obscureText,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      errorStyle: TextStyle(fontSize: 10),
                      suffixIcon: IconButton(
                        icon: Icon(obscureText
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                      ),
                    ),
                    onSaved: (contrasena) {
                      _contrasena = contrasena!;
                    },
                    validator: (value) =>
                        value!.isEmpty ? 'Enter your password' : null,
                    onTap: () {
                      setState(() {
                        _formKey.currentState!.reset();
                      });
                    },
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(15),
                  child:
                      CustomEButton(text: 'Iniciar', myFunction: _pantallaInicio)
                ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: CustomEButton(
                  text: 'Registro',
                  myFunction: openRegister
                ),
              ),
              TextButton(
                  onPressed:() {
                     olvidasteContrasena(context);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 33, 150, 243),
                  ),
                  child: const Text("¿Olvidaste tu contraseña?")),
            ],
          ),
        ),
      ),
    );
  }
}

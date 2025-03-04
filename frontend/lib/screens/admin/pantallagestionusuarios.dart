import 'package:flutter/material.dart';
import 'package:frontend_flutter/data/models/user.dart';
import 'package:frontend_flutter/commons/images.dart';
import 'package:frontend_flutter/commons/validations.dart';
import 'package:frontend_flutter/commons/constants.dart';
import 'package:frontend_flutter/providers/usuarioprovider.dart';
import 'package:frontend_flutter/widgets/formusuario.dart';
import 'package:frontend_flutter/commons/dialogs.dart';
import 'package:provider/provider.dart';

class AdministerManagementPage extends StatefulWidget {
  final User currentAdmin;
  const AdministerManagementPage({super.key, required this.currentAdmin});

  @override
  _AdministerManagementPageState createState() => _AdministerManagementPageState();
}

class _AdministerManagementPageState extends State<AdministerManagementPage> {
  
  void _createUser() {
    TextEditingController userController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController ageController = TextEditingController();
    String selectedTitle = "Sr.";
    String? imagePath;
    bool isAdmin = false;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          return AlertDialog(
            title: const Text("Crear Nuevo Usuario"),
            content: SingleChildScrollView(
              child: FormUsuario(
                isModified: false,
                userController: userController,
                passwordController: passwordController,
                ageController: ageController,
                selectedTitle: selectedTitle,
                imagenPath: imagePath,
                isAdmin: isAdmin,
                onTitleChanged: (value) => setDialogState(() => selectedTitle = value!),
                onImageChanged: (value) => setDialogState(() => imagePath = value),
                onAdminChanged: (value) => setDialogState(() => isAdmin = value!),
                onModifiedUser: (user) {},
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text("Cancelar"),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Validación de campos
                  String? userError =
                      Validations.validateRequired(userController.text);
                  String? passwordError =
                      Validations.validatePassword(passwordController.text);
                  String? ageError =
                      Validations.validateAge(ageController.text);

                  if (userError != null) {
                    Dialogs.showSnackBar(context, userError,
                        color: Constants.errorColor);
                    return;
                  }
                  if (passwordError != null) {
                    Dialogs.showSnackBar(context, passwordError,
                        color: Constants.errorColor);
                    return;
                  }
                  if (ageError != null) {
                    Dialogs.showSnackBar(context, ageError,
                        color: Constants.errorColor);
                    return;
                  }

                  await Dialogs.showLoadingSpinner(context);

                  User newUser = User(
                    id: 0,
                    trato: selectedTitle, //tengo que tocarlo despues, vamos avanzando-------------------------------------------------------------
                    nombre: userController.text,
                    contrasena: passwordController.text,
                    contrasena2: passwordController.text,
                    imagenPath: imagePath ?? Images.getDefaultImage(isAdmin),
                    edad: int.parse(ageController.text),
                    lugarNacimiento: "Madrid",
                    administrador: isAdmin,
                    //bloqueado: false,//tengo que tocarlo despues y parece que no hace falta-----------------------------------------------
                  );
                  final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
                  usuarioProvider.addUsuario(newUser);
                  Navigator.pop(dialogContext);
                  setState(() {});
                  Dialogs.showSnackBar(context, "Usuario creado correctamente",
                      color: Constants.successColor);
                },
                style: ElevatedButton.styleFrom
                (backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                ),
                child: const Text("Crear"),
              ),
            ],
          );
        },
      ),
    );
  }

  void _editUser(User user) {

    TextEditingController userController = TextEditingController(text: user.nombre);
    TextEditingController passwordController = TextEditingController(text: user.contrasena);
    TextEditingController ageController = TextEditingController(text: user.edad.toString());
    String selectedTitle = user.trato; 
    String? imagePath = user.imagenPath;
    bool isAdmin = user.administrador;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          return AlertDialog(
            title: const Text("Editar Usuario"),
            content: SingleChildScrollView(
              child: FormUsuario(
                isModified: true,
                userController: userController,
                passwordController: passwordController,
                ageController: ageController,
                selectedTitle: selectedTitle,
                imagenPath: imagePath,
                isAdmin: isAdmin,
                onTitleChanged: (value) => setDialogState(() => selectedTitle = value!),
                onImageChanged: (value) => setDialogState(() => imagePath = value),
                onAdminChanged: (value) => setDialogState(() => isAdmin = value!),
                onModifiedUser: (user) {},
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text("Cancelar"),
              ),
              ElevatedButton(
                onPressed: () async {
                  String? passwordError =
                      Validations.validatePassword(passwordController.text);
                  String? ageError =
                      Validations.validateAge(ageController.text);

                  if (passwordError != null) {
                    Dialogs.showSnackBar(context, passwordError,
                        color: Constants.errorColor);
                    return;
                  }
                  if (ageError != null) {
                    Dialogs.showSnackBar(context, ageError,
                        color: Constants.errorColor);
                    return;
                  }

                  await Dialogs.showLoadingSpinner(context);
                  /*User usuarioEditado = User(
                    id: user.id,
                    trato: selectedTitle,//tengo que editarlo ----------------------------------------------------------------------------- 
                    nombre: user.nombre,
                    contrasena: passwordController.text,
                    contrasena2: passwordController.text,
                    edad: int.parse(ageController.text),
                    imagenPath: imagePath ?? '',
                    lugarNacimiento: user.lugarNacimiento,
                    administrador: isAdmin
                  );*/
                  User usuarioEditado = user.copyWith(
                    trato: selectedTitle,
                    contrasena: passwordController.text,
                    contrasena2: passwordController.text,
                    edad: int.parse(ageController.text),
                    imagenPath: imagePath ?? '',
                    administrador: isAdmin,
                  );

                  final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
                  usuarioProvider.updateUsuario(user.id.toString(), usuarioEditado);

                  Navigator.pop(dialogContext);
                  setState(() {});
                  Dialogs.showSnackBar(
                      context, "Usuario actualizado correctamente",
                      color: Constants.successColor);
                },
                child: const Text("Guardar"),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context)  {
    final usuarioProvider = Provider.of<UsuarioProvider>(context);
    
      //.where((u) => u.nombre != "admin"&& u.nombre != widget.currentAdmin.nombre)
      //.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestión de Usuarios"),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: usuarioProvider.usuarios.length,
      itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: Images.getImageProvider(usuarioProvider.usuarios[index].getImagePath()),
                backgroundColor: Colors.grey[200],
              ),
              title: Row(
                children: [
                  Text(usuarioProvider.usuarios[index].nombre),
                  if (usuarioProvider.usuarios[index].administrador) const SizedBox(width: 4),
                  if (usuarioProvider.usuarios[index].administrador) Constants.adminBadge,
                ],
              ),
              subtitle: Text(
                "${usuarioProvider.usuarios[index].trato}-${usuarioProvider.usuarios[index].edad} años - ${usuarioProvider.usuarios[index].lugarNacimiento}"
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _editUser(usuarioProvider.usuarios[index]),
                  ),
                  IconButton(//---------------------------------------------------------------------------------------------------------------------------------------
                    icon: Icon(
                      usuarioProvider.usuarios[index].bloqueado ? Icons.lock : Icons.lock_open,
                      color: usuarioProvider.usuarios[index].bloqueado ? Colors.red : Colors.green,
                    ),
                    onPressed: () async {
                      User usuarioActual = usuarioProvider.usuarios[index];
                      User usuarioActualizado = usuarioActual.copyWith(bloqueado: !usuarioActual.bloqueado);
                      await usuarioProvider.updateUsuario(usuarioActual.id.toString(), usuarioActualizado);
                      Dialogs.showSnackBar(
                          context,
                          usuarioProvider.usuarios[index].bloqueado
                              ? "Usuario desbloqueado"
                              : "Usuario bloqueado",
                          color: usuarioProvider.usuarios[index].bloqueado
                              ? Constants.successColor
                              : Constants.errorColor);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      bool? confirm = await Dialogs.showConfirmDialog(
                          context: context,
                          title: "Confirmar eliminación",
                          content:
                              "¿Está seguro de eliminar a ${usuarioProvider.usuarios[index].nombre}?", 
                              style: Text(''));

                      if (confirm == true) {
                        await Dialogs.showLoadingSpinner(context);
                        usuarioProvider.deleteUsuario(usuarioProvider.usuarios[index].id);
                        setState(() {});
                        Dialogs.showSnackBar(
                            context, "Usuario eliminado correctamente",
                            color: Constants.successColor);
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createUser,
        backgroundColor: Constants.primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}

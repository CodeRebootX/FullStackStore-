import 'package:flutter/material.dart';
import 'package:frontend_flutter/data/models/user.dart';
import 'package:frontend_flutter/utils/validations.dart';
import 'package:frontend_flutter/utils/images.dart';

class FormUsuario extends StatelessWidget {
  final User? usuarioModified;
  final Function(User) onModifiedUser;
  final bool isModified;

  final TextEditingController userController;
  final TextEditingController passwordController;
  final TextEditingController ageController;
  final String selectedTitle;
  final String? imagenPath;
  final bool isAdmin;
  final Function(String?) onTitleChanged;
  final Function(String?) onImageChanged;
  final Function(bool?) onAdminChanged;

  const FormUsuario({
    super.key,
    this.usuarioModified,
    required this.onModifiedUser,
    required this.isModified,
    required this.userController,
    required this.passwordController,
    required this.ageController,
    required this.selectedTitle,
    required this.imagenPath,
    required this.isAdmin,
    required this.onTitleChanged,
    required this.onImageChanged,
    required this.onAdminChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButtonFormField<String>(
          value: selectedTitle,
          items: ["Sr.", "Sra."].map((trato) {
            return DropdownMenuItem(value: trato, child: Text(trato));
          }).toList(),
          onChanged: onTitleChanged,
          decoration: const InputDecoration(labelText: "Trato"),
        ),
        TextFormField(
          controller: userController,
          decoration: const InputDecoration(labelText: "Usuario"),
          enabled: !isModified,
          validator: Validations.validateRequired,
        ),
        TextFormField(
          controller: passwordController,
          decoration: const InputDecoration(labelText: "Contraseña"),
          obscureText: true,
          validator: Validations.validatePassword,
        ),
        TextFormField(
          controller: ageController,
          decoration: const InputDecoration(labelText: "Edad"),
          keyboardType: TextInputType.number,
          validator: Validations.validateAge,
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                imagenPath ?? "No se ha seleccionado imagen",
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              onPressed: () async {
                String? newPath = await Images.SelectImage();
                if (newPath != null) {
                  onImageChanged(newPath);
                }
              },
              icon: const Icon(Icons.image),
            ),
          ],
        ),
        CheckboxListTile(
          title: const Text("Es Administrador"),
          value: isAdmin,
          onChanged: onAdminChanged,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:frontend_flutter/data/models/user.dart';
import 'package:frontend_flutter/data/repositories/usuariorepository.dart';

class UsuarioProvider with ChangeNotifier {
  final Usuariorepository _usuariorepository = Usuariorepository();
  List<User> _usuarios = [];
  List<User> get usuarios => _usuarios;

  Future <void> fetchUsuarios() async {
    _usuarios = await _usuariorepository.getListaUsuarios();
    notifyListeners();
  }

  Future<List<User>> fetchListaUsuarios() async {
    return await _usuariorepository.getListaUsuarios();
  }

  Future<void> addUsuario(User usuario) async {
    await _usuariorepository.anadirUsuario(usuario);
    fetchUsuarios();
  }

  Future<void> updateUsuario(String id, User usuario) async {
    await _usuariorepository.actualizarUsuario(id, usuario);
    fetchUsuarios();
  }

  Future<void> deleteUsuario(int id) async {
    await _usuariorepository.eleminarUsuario(id);
    fetchUsuarios();
  }
}
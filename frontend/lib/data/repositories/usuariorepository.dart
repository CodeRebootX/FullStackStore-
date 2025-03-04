import 'package:frontend_flutter/data/models/user.dart';
import 'package:frontend_flutter/data/services/apiservice.dart';

class Usuariorepository {
  final ApiService _apiService = ApiService();

  Future<List<User>> getListaUsuarios() async {
    try {
      final response = await _apiService.dio.get("/users/getall");
      return (response.data as List)
          .map((json) => User.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception("Error al obtener usuarios");
    }
  }

  Future<void> anadirUsuario(User user) async {
    await _apiService.dio.post("/users", data:user.toJson());
  }

  Future<void> actualizarUsuario(String id, User user) async {
    await _apiService.dio.put("/users/$id", data: user.toJson());
  }

  Future<void> eleminarUsuario (int id) async {
    await _apiService.dio.delete("/users/$id");
  }
}
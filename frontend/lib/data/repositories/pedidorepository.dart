import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:frontend_flutter/data/models/order.dart';
import 'package:frontend_flutter/data/models/orderdetail.dart';
import 'package:frontend_flutter/data/models/product.dart';
import 'package:frontend_flutter/data/services/apiservice.dart';

class PedidoRepository {
  final ApiService _apiService = ApiService();

  Future<List<Order>> getListaPedidos() async {
    try {
      final response = await _apiService.dio.get("/pedidos/getall");
      return (response.data as List)
        .map((json) => Order.fromJson(json))
        .toList();
    } catch (e) {
      print("Error al obtener pedidos: $e");
      throw Exception("Error al obtner pedidos");
    }
  }

  Future<List<Order>> getPedidosPorUsuario(int id) async {
    try {
      final response = await _apiService.dio.get("/pedidos/usuario/$id");
      return (response.data as List)
        .map((json) => Order.fromJson(json))
        .toList();
    } catch (e) {
      throw Exception("Error al obtener pedidos del usuario");
    }
  }

  Future<void> anadirPedido(Order pedido) async {
  try {
    print("Enviando pedido a la API: ${pedido.toJson()}");
    final response = await _apiService.dio.post("/pedidos", data: pedido.toJson());

    if (response.statusCode == 200) {
      print("Pedido creado correctamente: ${response.data}");
    } else {
      print("Respuesta inesperada de la API: ${response.statusCode} - ${response.data}");
    }
  } catch (e) {
    if (e is DioException) {
      print("Error en la API: ${e.response?.statusCode} - ${e.response?.data}");
    } else {
      print("Error desconocido: $e");
    }
  }
}

  Future<void> actualizarPedido(String id, Order pedido) async {
    await _apiService.dio.put("/pedidos/$id", data: pedido.toJson());
  }

  Future<void> eliminarPedido(int id) async {
    await _apiService.dio.delete("/pedidos/$id");
  }
  
}
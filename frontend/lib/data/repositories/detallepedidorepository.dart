import 'package:frontend_flutter/data/models/orderdetail.dart';
import 'package:frontend_flutter/data/services/apiservice.dart';

class DetallePedidoRepository {
  final ApiService _apiService = ApiService();

  Future<List<DetallePedido>> getListaDetalles() async {
    try {
      final response = await _apiService.dio.get("/detalles_pedido/getall");
      return (response.data as List)
          .map((json) => DetallePedido.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception("Error al obtener detalles de pedidos");
    }
  }

  Future<void> anadirDetallePedido(DetallePedido detalle) async {
    await _apiService.dio.post("/detalles_pedido", data: detalle.toJson());
  }

  Future<void> actualizarDetallePedido(String id, DetallePedido detalle) async {
    await _apiService.dio.put("/detalles_pedido/$id", data: detalle.toJson());
  }

  Future<void> eliminarDetallePedido(int id) async {
    await _apiService.dio.delete("/detalles_pedido/$id");
  }
}
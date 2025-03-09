import 'package:flutter/material.dart';
import 'package:frontend_flutter/data/models/order.dart';
import 'package:frontend_flutter/data/repositories/pedidorepository.dart';

class PedidoProvider with ChangeNotifier {
  final PedidoRepository _pedidoRepository = PedidoRepository();
  List<Order> _pedidos = [];

  List<Order> get pedidos => _pedidos;


  Future<void> fetchPedidos() async {
    try {
      _pedidos = await _pedidoRepository.getListaPedidos();
      notifyListeners();
    } catch (e) {
      print("Error al obtener pedidos: $e");
    }
  }


  Future<List<Order>> fetchPedidosPorUsuario(int usuarioId) async {
    return await _pedidoRepository.getPedidosPorUsuario(usuarioId);
  }


  Future<void> addPedido(Order pedido) async {
    await _pedidoRepository.anadirPedido(pedido);
    fetchPedidos();
  }

  Future<void> deletePedido(int id) async {
    await _pedidoRepository.eliminarPedido(id);
    fetchPedidos();
  }

  Future<void> updatePedidoEstado(int id, String estado) async {
    await _pedidoRepository.actualizarPedido(id, estado);
    fetchPedidos();
  }

}

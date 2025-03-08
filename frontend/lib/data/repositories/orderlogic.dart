import '../models/order.dart';

class OrderLogic {
  static final List<Order> pedidos = [];

  static void addOrder(Order pedido) {
    pedidos.add(pedido);
  }

  
}

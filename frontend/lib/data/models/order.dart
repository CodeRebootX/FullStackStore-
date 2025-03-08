import 'package:frontend_flutter/data/models/orderdetail.dart';

class Order {
  int id;
  double total;
  String estado;
  int usuarioId;
  List<DetallePedido> productos;

  Order({
    required this.id,
    required this.total,
    required this.estado,
    required this.usuarioId,
    required this.productos,
  });


  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      total: json['total'],
      estado: json['estado'],
      usuarioId: json['usuarioId'],
      productos: (json['productos'] as List)
          .map((item) => DetallePedido.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "total": total,
      "estado": estado,
      "usuarioId": usuarioId,
      "productos": productos.isNotEmpty
        ? {for (var d in productos) d.productoId: d.cantidad}
        : {},
    };
  }
}



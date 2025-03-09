import 'package:frontend_flutter/data/models/orderdetail.dart';
import 'package:frontend_flutter/data/models/user.dart';

class Order {
  int id;
  double total;
  String estado;
  User usuario;
  List<DetallePedido> detalles;

  Order({
    required this.id,
    required this.total,
    required this.estado,
    required this.usuario,
    required this.detalles,
  });


  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      total: json['total'],
      estado: json['estado'],
      usuario: User.fromJson(json['usuario']),
      detalles: (json['detalles'] as List)
          .map((item) => DetallePedido.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "total": total,
      "estado": estado,
      "usuario": usuario.toJson(),
      "productos": detalles.map((d) => d.toJson()).toList(),
    };
  }
}



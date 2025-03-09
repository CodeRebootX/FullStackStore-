import 'package:frontend_flutter/data/models/product.dart';

class DetallePedido {
  int id;
  Product producto;
  int cantidad;
  double precio;

  DetallePedido({
    required this.id,
    required this.producto,
    required this.cantidad,
    required this.precio,
  });

  factory DetallePedido.fromJson(Map<String, dynamic> json) {
    return DetallePedido(
      id: json['id'],
      producto: Product.fromJson(json['producto']),
      cantidad: json['cantidad'],
      precio: json['precio'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "producto": producto.toJson(),
      "cantidad": cantidad,
      "precio": precio,
    };
  }
}
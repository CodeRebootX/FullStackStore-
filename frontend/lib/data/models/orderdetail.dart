class DetallePedido {
  int id;
  int productoId;
  int cantidad;
  double precio;

  DetallePedido({
    required this.id,
    required this.productoId,
    required this.cantidad,
    required this.precio,
  });

  factory DetallePedido.fromJson(Map<String, dynamic> json) {
    return DetallePedido(
      id: json['id'],
      productoId: json['productoId'],
      cantidad: json['cantidad'],
      precio: json['precio'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "producto": productoId,
      "cantidad": cantidad,
      "precio": precio,
    };
  }


}
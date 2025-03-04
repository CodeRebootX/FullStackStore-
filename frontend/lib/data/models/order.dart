class Order {
  int id;
  double total;
  String estado;
  String comprador;
  Map<int, int> productos;

  Order({
    required this.id,
    required this.total,
    required this.estado,
    required this.comprador,
    required this.productos,
  });
}

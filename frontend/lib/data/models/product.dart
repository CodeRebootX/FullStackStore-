class Product {
  int id;
  String nombre;
  String descripcion;
  String imagenPath;
  int stock;
  double precio;

  Product({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.imagenPath,
    required this.stock,
    required this.precio,
  });

  factory Product.empty() {
    return Product(
      id: 0,
      nombre: '',
      descripcion: '',
      imagenPath: '',
      stock: 0,
      precio: 0.0,
    );
  }

  Product copyWith({
    int? id,
    String? nombre,
    String? descripcion,
    String? imagenPath,
    int? stock,
    double? precio,
  }) {
    return Product(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      imagenPath: imagenPath ?? this.imagenPath,
      stock: stock ?? this.stock,
      precio: precio ?? this.precio,
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, nombre: $nombre, descripcion: $descripcion, imagenPath: $imagenPath, stock: $stock, precio: $precio)';
  }

  int getId() => id;
  String getNombre() => nombre;
  String getDescripcion() => descripcion;
  String getImagenPath() => imagenPath;
  int getStock() => stock;
  double getPrecio() => precio;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'] ?? '',
      imagenPath: json['imagenPath'] ?? '',
      stock: json['stock'] ?? 0,
      precio: (json['precio'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nombre": nombre,
      "descripcion": descripcion,
      "imagenPath": imagenPath,
      "stock": stock,
      "precio": precio,
    };
  }

}

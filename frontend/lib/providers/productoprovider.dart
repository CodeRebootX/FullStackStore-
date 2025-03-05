import 'package:flutter/material.dart';
import 'package:frontend_flutter/data/models/product.dart';
import 'package:frontend_flutter/data/repositories/productorepository.dart';

class ProductoProvider with ChangeNotifier {
  final ProductRepository _productrepository = ProductRepository();
  List<Product> _productos = [];
  bool _productosInicializados = false;
  List<Product> get productos => _productos;
  

  Future <void> fetchProductos() async {
    _productos = await _productrepository.getListaProductos();

    if (_productos.isEmpty && !_productosInicializados) {
      _productosInicializados = true;
      await _productosPorDefecto();
    }
    notifyListeners();
  }

  Future<void> _productosPorDefecto() async {
    List<Product> productosEnBD = await _productrepository.getListaProductos();

    if (productosEnBD.isNotEmpty) return;

    List<Product> productosPorDefecto = [
      Product(
        id: 0,
        nombre: "Caldera Vaillant",
        descripcion: "Aire acondicionado elegante y eficiente con tecnología avanzada de control y purificación del aire.",
        imagenPath: "assets/images/caldera_vaillant.png",
        stock: 10,
        precio: 850.0,
      ),
      Product(
        id: 0,
        nombre: "Aire Acondicionado Mitsubishi",
        descripcion: "Split premium con alta eficiencia energética, filtrado avanzado y control inteligente.",
        imagenPath: "assets/images/mitsubishi_aire.png",
        stock: 5,
        precio: 1500.0,
      ),
      Product(
        id: 0,
        nombre: "Aire Acondicionado Daikin",
        descripcion: "Aire acondicionado elegante y eficiente con tecnología avanzada de control y purificación del aire.",
        imagenPath: "assets/images/daikin_aire.png",
        stock: 8,
        precio: 975.0,
      ),
    ];

    for (var producto in productosPorDefecto) {
      await _productrepository.anadirProducto(producto);
    }

    _productos = await _productrepository.getListaProductos();
    notifyListeners();
  }

  Future<List<Product>> fetchListaProductos() async {
    return await _productrepository.getListaProductos();
  }

  Future<void> addProducto(Product product) async {
    await _productrepository.anadirProducto(product);
    fetchProductos();
  }

  Future<void> updateProducto(String id, Product product) async {
    await _productrepository.actualizarProducto(id, product);
    fetchProductos();
  }

  Future<void> deleteProducto(int id) async {
    await _productrepository.eleminarProducto(id);
    fetchProductos();
  }
}
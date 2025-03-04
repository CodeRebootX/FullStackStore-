import 'package:flutter/material.dart';
import 'package:frontend_flutter/data/models/product.dart';
import 'package:frontend_flutter/data/repositories/productorepository.dart';

class ProductoProvider with ChangeNotifier {
  final ProductRepository _productrepository = ProductRepository();
  List<Product> _productos = [];
  List<Product> get productos => _productos;

  Future <void> fetchProductos() async {
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
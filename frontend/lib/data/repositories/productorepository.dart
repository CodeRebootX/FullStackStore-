import 'package:frontend_flutter/data/services/apiservice.dart';
import 'package:frontend_flutter/data/models/product.dart';


class ProductRepository {
  final ApiService _apiService = ApiService();

  Future<List<Product>> getListaProductos() async {
    try {
      final response = await _apiService.dio.get("/products/getall");
      return (response.data as List)
          .map((json) => Product.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception("Error al obtener productos");
    }
  }

  Future<void> anadirProducto(Product product) async {
    await _apiService.dio.post("/products", data:product.toJson());
  }

  Future<void> actualizarProducto(String id, Product product) async {
    await _apiService.dio.put("/products/$id", data: product.toJson());
  }

  Future<void> eleminarProducto (int id) async {
    await _apiService.dio.delete("/products/$id");
  }
}
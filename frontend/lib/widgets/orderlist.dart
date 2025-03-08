import 'package:flutter/material.dart';
import 'package:frontend_flutter/data/models/order.dart';
import 'package:frontend_flutter/data/models/product.dart';
import 'package:frontend_flutter/commons/images.dart';
import 'package:frontend_flutter/commons/constants.dart';
import 'package:frontend_flutter/commons/priceformat.dart';
import 'package:frontend_flutter/data/repositories/productorepository.dart';

class OrderListItem extends StatefulWidget {
  final Order pedido;
  final ValueChanged<String?>? onEstadoChanged;

  const OrderListItem({
    super.key,
    required this.pedido,
    this.onEstadoChanged,
  });

  @override
  _OrderListItemState createState() => _OrderListItemState();
}

class _OrderListItemState extends State<OrderListItem> {

  late Future<List<Product>> futureProductos;

  @override
  void initState() {
    super.initState();
    futureProductos = ProductRepository().getListaProductos();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: futureProductos,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator()
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text(
              "Error al cargar los productos",
              style: TextStyle(
                fontSize: 16,
                color: Colors.red
              ),
            ),
          );
        }
        List<Product> productos = snapshot.data ?? [];

        return Card(
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pedido: ${widget.pedido.id}",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Usuario: ${widget.pedido.usuarioId}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                ...widget.pedido.productos.map((detalle) {
                  final producto = productos.firstWhere(
                    (p) => p.id == detalle.productoId,
                    orElse: () => Product(
                      id: detalle.productoId,
                      nombre: 'Producto desconocido',
                      descripcion: '',
                      imagenPath: '',
                      stock: 0,
                      precio: 0.0
                    ),
                  );
                  return buildProductoItem(producto, detalle.cantidad);
                }),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total: ${PriceFormat.formatPrice(widget.pedido.total)}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (widget.onEstadoChanged != null)
                      buildEstadoDropdown()
                    else
                      buildEstadoText(),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildProductoItem(Product producto, int cantidad) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: Image(
              image: Images.getImageProvider(producto.imagenPath),
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(producto.nombre),
                Text("Cantidad: $cantidad"),
                Text("Precio unitario: ${PriceFormat.formatPrice(producto.precio)}"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEstadoDropdown() {
    return DropdownButton<String>(
      value: widget.pedido.estado,
      items: Constants.estadoIconos.keys.map((estado) {
        return DropdownMenuItem<String>(
          value: estado,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Constants.estadoIconos[estado],
                color: Constants.estadoColores[estado],
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                estado,
                style: TextStyle(color: Constants.estadoColores[estado]),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: widget.onEstadoChanged,
    );
  }

  Widget buildEstadoText() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Constants.estadoIconos[widget.pedido.estado],
          color: Constants.estadoColores[widget.pedido.estado],
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          widget.pedido.estado,
          style: TextStyle(
            color: Constants.estadoColores[widget.pedido.estado],
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

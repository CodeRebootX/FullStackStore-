import 'package:flutter/material.dart';
import 'package:frontend_flutter/commons/priceformat.dart';
import 'package:frontend_flutter/data/repositories/orderlogic.dart';
import 'package:frontend_flutter/data/models/user.dart';
import 'package:frontend_flutter/data/models/product.dart';
import 'package:frontend_flutter/commons/snacksbar.dart';
import 'package:frontend_flutter/commons/constants.dart';
import 'package:frontend_flutter/data/models/order.dart';
import 'package:frontend_flutter/providers/productoprovider.dart';
import 'package:frontend_flutter/widgets/productlist.dart';
import 'package:provider/provider.dart';


class ShoppingPage extends StatefulWidget {
  final User usuario;
  const ShoppingPage({super.key, required this.usuario});

  @override
  _ShoppingPageState createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  late ProductoProvider productoProvider;
  Map<int, int> cantidades = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        productoProvider = Provider.of<ProductoProvider>(context, listen: false);
        productoProvider.fetchProductos();
      });
    });
  }

  double calcularTotal() {
    double total = 0;
    for (var producto in productoProvider.productos) {
      int cantidad = cantidades[producto.id] ?? 0;
      total += cantidad * producto.precio;
    }
    return total;
  }

  void incrementarCantidad(Product producto) {
    setState(() {
      int cantidadActual = cantidades[producto.id] ?? 0;
      if (cantidadActual < producto.stock) {
        cantidades[producto.id] = cantidadActual + 1;
      } else {
        SnaksBar.showSnackBar(
          context, "No hay suficiente stock disponible",
          color: Constants.warningColor
        );
      }
    });
  }

  void decrementarCantidad(Product producto) {
    setState(() {
      int cantidadActual = cantidades[producto.id] ?? 0;
      if (cantidadActual > 0) {
        cantidades[producto.id] = cantidadActual - 1;
      }
    });
  }

  bool validarStock() {
    for (var producto in productoProvider.productos) {
      int cantidad = cantidades[producto.id] ?? 0;
      if (cantidad > producto.stock) {
        SnaksBar.showSnackBar(
          context, "${producto.nombre}: No hay suficiente stock. Stock disponible: ${producto.stock}",
          color: Constants.errorColor
        );
        return false;
      }
    }
    return true;
  }

  void realizarCompra() {
    bool hayProductos = cantidades.values.any((cantidad) => cantidad > 0);
    if (!hayProductos) {
      SnaksBar.showSnackBar(
        context, "Seleccione al menos un producto",
        color: Constants.warningColor
      );
      return;
    }

    if (!validarStock()) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        double total = calcularTotal();
        return AlertDialog(
          title: const Text("Confirmar Compra"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Resumen del pedido:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  )
                ),
                const SizedBox(height: 8),
                ...productoProvider.productos.map((producto) {
                  int cantidad = cantidades[producto.id] ?? 0;
                  if (cantidad > 0) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                          "${producto.nombre}: $cantidad x ${PriceFormat.formatPrice(producto.precio)}"
                        ),
                    );
                  }
                  return const SizedBox.shrink();
                }).whereType<Padding>(),
                const Divider(),
                Text(
                  "Total: ${PriceFormat.formatPrice(total)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold
                  )
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                confirmarCompra();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blueAccent,
                textStyle: const TextStyle(fontSize: 15),
              ),
              child: const Text("Confirmar"),
            ),
          ],
        );
      },
    );
  }

  void confirmarCompra() async {

    int pedidoId = 00000000000;
    Map<int, int> productosComprados = {};

    for (var producto in productoProvider.productos) {
      int cantidad = cantidades[producto.id] ?? 0;
      if (cantidad > 0) {
        if (cantidad <= producto.stock) {
          productosComprados[producto.id] = cantidad;
          producto.stock -= cantidad;
          await productoProvider.updateProducto(producto.id.toString(),producto);
        } else {
          SnaksBar.showSnackBar(
              context, "Error: Stock insuficiente para ${producto.nombre}",
              color: Constants.errorColor);
          return;
        }
      }
    }
//----------------------------------------------------------------------------------------------
    Order pedido = Order(
      id: pedidoId,
      comprador: widget.usuario.nombre,
      productos: productosComprados,
      total: calcularTotal(),
      estado: "Pedido",
    );

    OrderLogic.addOrder(pedido);
    SnaksBar.showSnackBar(context, "Compra realizada con éxito",
        color: Constants.successColor);
    setState(() {
      cantidades.clear();
    });
  }
//----------------------------------------------------------------------------------------------
 @override
  Widget build(BuildContext context) {


    return Consumer<ProductoProvider>(
      builder: (context, provider, child) {
        if (provider.productos.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  if (provider.productos.isEmpty)
                    const Center(
                      child: Text(
                        "No hay productos disponibles",
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  else
                    ...provider.productos.map((producto) {
                      int currentQuantity = cantidades[producto.id] ?? 0;
                      return ProductListItem(
                        producto: producto,
                        cantidad: currentQuantity,
                        onIncrement: () => incrementarCantidad(producto),
                        onDecrement: () => decrementarCantidad(producto),
                      );
                    }),
                  const SizedBox(height: 80),
                ],
              ),
            ),
            Positioned(
              bottom: 16,
              left: 150,
              right: 150,
              child: ElevatedButton(
                onPressed: realizarCompra,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                  textStyle: const TextStyle(fontSize: 15),
                ),
                child: const Text("Realizar Compra"),
              ),
            ),
          ],
        );
      },
    );
  }
}
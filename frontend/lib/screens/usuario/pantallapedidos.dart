import 'package:flutter/material.dart';
import 'package:frontend_flutter/data/repositories/pedidorepository.dart';
import 'package:frontend_flutter/widgets/orderlist.dart';
import 'package:frontend_flutter/data/models/user.dart';
import 'package:frontend_flutter/data/models/order.dart';


class OrdersPage extends StatefulWidget {
  final User usuario;

  const OrdersPage({
    super.key,
    required this.usuario,
  });

  @override
  _OrdersPageState createState () => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {

  late Future<List<Order>> futurePedidos;

  @override
  void initState() {
    super.initState();
    futurePedidos = PedidoRepository().getPedidosPorUsuario(widget.usuario.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Order>>(
      future: futurePedidos,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(
            child: Text(
              "Error al cargar los pedidos",
              style: TextStyle(
                fontSize: 18,
                color: Colors.red
              ),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              "No has realizado ningún pedido",
              style: TextStyle(
                fontSize: 18,
                color: Colors.orange
              ),
            ),
          );
        }

        List<Order> pedidos = snapshot.data!;

        return ListView.builder(
          itemCount: pedidos.length,
          itemBuilder: (context, index) {
            Order pedido = pedidos[index];
            return OrderListItem(
              pedido: pedido
            );
          },
        );
      },
    );
  }
}

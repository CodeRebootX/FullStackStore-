import 'package:flutter/material.dart';
import 'package:frontend_flutter/providers/pedidoprovider.dart';
import 'package:frontend_flutter/widgets/orderlist.dart';
import 'package:frontend_flutter/data/models/order.dart';
import 'package:frontend_flutter/commons/dialogs.dart';
import 'package:frontend_flutter/commons/constants.dart';
import 'package:provider/provider.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  _MyOrdersPageState createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  Future<void> _confirmAndChangeEstado(
      Order pedido, String? nuevoEstado) async {
    if (nuevoEstado == null) return;

    bool? confirmado = await Dialogs.showConfirmDialog(
        context: context,
        title: "Confirmar cambio de estado",
        content:
            "¿Está seguro de cambiar el estado del pedido a '$nuevoEstado'?", style: Text(''));

    if (confirmado != true) return;

    await Dialogs.showLoadingSpinner(context);

    setState(() {
      pedido.estado = nuevoEstado;
    });

    Dialogs.showSnackBar(context, "Estado actualizado a '$nuevoEstado'",
        color: Constants.estadoColores[nuevoEstado]);
  }

  @override
  Widget build(BuildContext context) {
    final pedidoProvider = Provider.of<PedidoProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestión de Pedidos"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        itemCount: pedidoProvider.pedidos.length,
        itemBuilder: (context, index) {
          return OrderListItem(
            pedido: pedidoProvider.pedidos[index],
            onEstadoChanged: (nuevoEstado) {
              if (nuevoEstado != pedidoProvider.pedidos[index].estado) {
                _confirmAndChangeEstado(pedidoProvider.pedidos[index], nuevoEstado);
              }
            },
          );
        },
      ),
    );
  }
}
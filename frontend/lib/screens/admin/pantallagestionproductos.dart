import 'package:flutter/material.dart';
import 'package:frontend_flutter/data/models/product.dart';
import 'package:frontend_flutter/utils/producto.dart';
import 'package:frontend_flutter/utils/validations.dart';
import 'package:frontend_flutter/utils/dialogs.dart';
import 'package:frontend_flutter/utils/images.dart';
import 'package:frontend_flutter/utils/constants.dart';
import 'package:frontend_flutter/providers/productoprovider.dart';
import 'package:provider/provider.dart';

class MyProductPage extends StatefulWidget {
  const MyProductPage({super.key});

  @override
  _MyProductPageState createState() => _MyProductPageState();
}

class _MyProductPageState extends State<MyProductPage> {
  
  void _nuevoProducto() {
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController stockController = TextEditingController();
    String? PathImage;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          return AlertDialog(
            title: const Text("Crear Nuevo Producto"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: "Nombre"),
                    validator: Validations.validateRequired,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: "Descripción"),
                  ),
                  TextFormField(
                    controller: priceController,
                    decoration: const InputDecoration(labelText: "Precio"),
                    keyboardType: TextInputType.number,
                    validator: Validations.validatePrice,
                  ),
                  TextFormField(
                    controller: stockController,
                    decoration: const InputDecoration(labelText: "Stock"),
                    keyboardType: TextInputType.number,
                    validator: Validations.validateStock,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          PathImage ?? "No se ha seleccionado imagen",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          String? newPath = await Images.SelectImage();
                          if (newPath != null) {
                            setDialogState(() => PathImage = newPath);
                          }
                        },
                        icon: const Icon(Icons.image),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text("Cancelar"),
              ),
              TextButton(
                onPressed: () async {
                  if (Validations.validateRequired(nameController.text) !=
                          null ||
                      Validations.validatePrice(priceController.text) != null ||
                      Validations.validateStock(stockController.text) != null) {
                    Dialogs.showSnackBar(
                      context, "Por favor, complete todos los campos correctamente",
                      color: Constants.errorColor
                    );
                    return;
                  }

                  await Dialogs.showLoadingSpinner(context);
                  Product newProduct = Product(
                    id: 0,
                    nombre: nameController.text,
                    descripcion: descriptionController.text,
                    imagenPath: PathImage ?? Images.getDefaultImage(false),
                    stock: int.parse(stockController.text),
                    precio: double.parse(priceController.text)
                  );

                  final ProductoProvider productoProvider = Provider.of<ProductoProvider>(context, listen: false);
                  productoProvider.addProducto(newProduct);

                  Navigator.pop(dialogContext);
                  setState(() {});
                  Dialogs.showSnackBar(
                    context, "Producto creado correctamente",
                    color: Constants.successColor
                  );
                },
                style: ElevatedButton.styleFrom
                (backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                ),
                child: const Text("Crear"),
              ),
            ],
          );
        },
      ),
    );
  }

  void _editProduct(Product product) {
    TextEditingController nombreController = TextEditingController(text: product.nombre);
    TextEditingController descripcionController = TextEditingController(text: product.descripcion);
    TextEditingController precioController = TextEditingController(text: product.precio.toString());
    TextEditingController stockController = TextEditingController(text: product.stock.toString());
    String? imagenPath = product.imagenPath;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          return AlertDialog(
            title: const Text("Editar Producto"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nombreController,
                    decoration: const InputDecoration(labelText: "Nombre"),
                    validator: Validations.validateRequired,
                  ),
                  TextFormField(
                    controller: descripcionController,
                    decoration: const InputDecoration(labelText: "Descripción"),
                  ),
                  TextFormField(
                    controller: precioController,
                    decoration: const InputDecoration(labelText: "Precio"),
                    keyboardType: TextInputType.number,
                    validator: Validations.validatePrice,
                  ),
                  TextFormField(
                    controller: stockController,
                    decoration: const InputDecoration(labelText: "Stock"),
                    keyboardType: TextInputType.number,
                    validator: Validations.validateStock,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          imagenPath ?? "No se ha seleccionado imagen",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          String? newPath = await Images.SelectImage();
                          if (newPath != null) {
                            setDialogState(() => imagenPath = newPath);
                          }
                        },
                        icon: const Icon(Icons.image),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text("Cancelar"),
              ),
              TextButton(
                onPressed: () async {
                  if (Validations.validateRequired(nombreController.text) != null ||
                      Validations.validatePrice(precioController.text) != null ||
                      Validations.validateStock(stockController.text) != null) {
                    Dialogs.showSnackBar(
                      context, "Por favor, complete todos los campos correctamente",
                      color: Constants.errorColor
                    );
                    return;
                  }

                  await Dialogs.showLoadingSpinner(context);

                  Product productoEditado = product.copyWith(
                    nombre: nombreController.text,
                    descripcion: descripcionController.text,
                    imagenPath: imagenPath ?? Images.getDefaultImage(false),
                    stock: int.parse(stockController.text),
                    precio: double.parse(precioController.text.replaceAll(',', '.')),
                  );

                  final productoProvider = Provider.of<ProductoProvider>(context, listen: false);
                  productoProvider.updateProducto(product.id.toString(), productoEditado);

                  Navigator.pop(dialogContext);
                  setState(() {});
                  Dialogs.showSnackBar(
                    context, "Producto actualizado correctamente",
                    color: Constants.successColor
                  );
                },
                child: const Text("Guardar"),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final productoProvider = Provider.of<ProductoProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestión de Productos"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: productoProvider.productos.length,
            itemBuilder: (context, index) {
              return CustomProducto(
                product: productoProvider.productos[index],
                onEdit: () => _editProduct(productoProvider.productos[index]),
                onDelete: () async {
                  bool? confirmar = await Dialogs.showConfirmDialog(
                    context: context,
                    title: "Confirmar eliminación",
                    content: "¿Está seguro de eliminar ${productoProvider.productos[index].nombre}?",
                    style: Text('')
                  );

                  if (confirmar == true) {
                    await Dialogs.showLoadingSpinner(context);
                    productoProvider.deleteProducto(productoProvider.productos[index].id);
                    Dialogs.showSnackBar(
                      context, "Producto eliminado correctamente",
                      color: Constants.successColor
                    );
                  }
                },
              );
            },
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: Constants.primaryColor,
              foregroundColor: Colors.white,
              onPressed: _nuevoProducto,
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}

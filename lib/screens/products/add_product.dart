import 'package:flutter/material.dart';
import 'package:registro_productos/components/app_bar.dart';

class AddProductScreen extends StatefulWidget {
  final String initialBarcode;

  const AddProductScreen({
    super.key,
    required this.initialBarcode,
  });

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController barcodeController;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();

  @override
  void initState() {
    super.initState();
    barcodeController = TextEditingController(text: widget.initialBarcode);
  }

  @override
  void dispose() {
    barcodeController.dispose();
    nameController.dispose();
    priceController.dispose();
    stockController.dispose();
    super.dispose();
  }

  void saveProduct() {
    if (_formKey.currentState!.validate()) {
      // Aquí llamas a tu Provider o API
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto guardado')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Agregar producto"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: barcodeController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Código de barras",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Nombre",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                v!.isEmpty ? "Ingresa un nombre" : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: "Precio",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (v) =>
                v!.isEmpty ? "Ingresa un precio" : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: stockController,
                decoration: const InputDecoration(
                  labelText: "Stock",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (v) =>
                v!.isEmpty ? "Ingresa el stock" : null,
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: saveProduct,
                child: const Text("Guardar producto"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

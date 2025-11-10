import 'package:flutter/material.dart';
import '../../data/inventory_data.dart';
import '../admin/inventory_screen.dart';

class NewProductScreen extends StatefulWidget {
  final String codigo;
  const NewProductScreen({super.key, required this.codigo});

  @override
  State<NewProductScreen> createState() => _NewProductScreenState();
}

class _NewProductScreenState extends State<NewProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreCtrl = TextEditingController();
  final TextEditingController _precioCtrl = TextEditingController();
  final TextEditingController _descripcionCtrl = TextEditingController();
  final TextEditingController _stockCtrl = TextEditingController();
  String? categoriaSeleccionada; // Ahora usamos un Dropdown

  void guardarProducto() {
    if (_formKey.currentState?.validate() ?? false) {
      final producto = {
        'codigo': widget.codigo,
        'nombre': _nombreCtrl.text,
        'precio': _precioCtrl.text,
        'descripcion': _descripcionCtrl.text,
        'stock': _stockCtrl.text,
        'categoria': categoriaSeleccionada ?? '',
      };

      inventario.add(producto);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto registrado')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const InventoryScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Producto Nuevo")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text('Código: ${widget.codigo}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nombreCtrl,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Ingrese nombre' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _precioCtrl,
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Ingrese precio' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _stockCtrl,
                decoration: const InputDecoration(labelText: 'Stock inicial'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descripcionCtrl,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Dropdown de categorías (solo selección)
              DropdownButtonFormField<String>(
                initialValue: categoriaSeleccionada,
                items: categorias
                    .map((cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(cat),
                        ))
                    .toList(),
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                ),
                onChanged: (v) {
                  setState(() {
                    categoriaSeleccionada = v;
                  });
                },
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Seleccione categoría' : null,
              ),

              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: guardarProducto,
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

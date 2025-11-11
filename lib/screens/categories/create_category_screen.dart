import 'package:flutter/material.dart';

class CreateCategoryScreen extends StatefulWidget {
  const CreateCategoryScreen({super.key});

  @override
  State<CreateCategoryScreen> createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends State<CreateCategoryScreen> {
  final TextEditingController _categoriaCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void guardarCategoria() {
    if (_formKey.currentState?.validate() ?? false) {
      // Devuelve la nueva categoría al pop
      Navigator.pop(context, _categoriaCtrl.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Crear Nueva Categoría")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _categoriaCtrl,
                decoration:
                    const InputDecoration(labelText: 'Nombre de categoría'),
                validator: (v) => (v == null || v.isEmpty)
                    ? 'Ingrese nombre de categoría'
                    : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: guardarCategoria,
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

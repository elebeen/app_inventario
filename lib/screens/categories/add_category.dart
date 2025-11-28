import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:registro_productos/provider/category_provider.dart';
import 'package:registro_productos/components/app_bar.dart';

class CreateCategoryScreen extends StatefulWidget {
  const CreateCategoryScreen({super.key});

  @override
  State<CreateCategoryScreen> createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends State<CreateCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _categoriaCtrl = TextEditingController();

  Future<void> guardarCategoria() async {
    if (!_formKey.currentState!.validate()) return;

    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    await categoryProvider.createCategory(_categoriaCtrl.text);

    if (!mounted) return;

    if (categoryProvider.errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Categoría creada')),
      );

      Navigator.pop(context);
      categoryProvider.resetCategories();
      categoryProvider.fetchCategories();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(categoryProvider.errorMessage!),
          backgroundColor: Colors.red
        ),
      );
    }
  }

  @override
  void dispose() {
    _categoriaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final category = context.watch<CategoryProvider>();

    return Scaffold(
      appBar: CustomAppBar(title: 'Agregar Categoría'),
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
                onPressed: category.isLoading ? null : guardarCategoria,
                child: category.isLoading ? 
                  const CircularProgressIndicator() : 
                  const Text('Guardar'),
              ),
              if (category.errorMessage != null)
                Text(
                  category.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

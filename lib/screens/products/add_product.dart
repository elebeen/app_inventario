import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:registro_productos/components/app_bar.dart';
import 'package:registro_productos/provider/category_provider.dart';
import 'package:registro_productos/provider/product_provider.dart';

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
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    barcodeController = TextEditingController(text: widget.initialBarcode);
    // cargar categorías después del primer frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
    });
  }

  @override
  void dispose() {
    barcodeController.dispose();
    nameController.dispose();
    priceController.dispose();
    stockController.dispose();
    super.dispose();
  }

  Future<void> saveProduct() async {
    // 1. Validar el formulario localmente
    if (!_formKey.currentState!.validate()) return;

    // 2. Validar la categoría
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona una categoría')),
      );
      return;
    }

    // 3. Obtener el provider (sin escuchar cambios, solo para llamar al método)
    final productProvider = Provider.of<ProductProvider>(context, listen: false);

    // 4. Llamar a crear producto y ESPERAR (await) el resultado
    await productProvider.createProduct(
      barcodeController.text,
      nameController.text,
      double.parse(priceController.text),
      int.parse(stockController.text),
      _selectedCategoryId!,
    );

    // Verificar si el widget sigue montado antes de usar el contexto
    if (!mounted) return;

    // 5. Verificar si hubo error en el provider
    if (productProvider.errorMessage == null) {
      // ÉXITO: Mostrar mensaje y regresar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto guardado')),
      );
      
      // Resetear el loading y la lista de productos
      productProvider.refreshProducts();
      productProvider.clearLoading();
      print("Productos cargados add_product_screen");
      
      // Usamos pop porque esta pantalla está "encima" de la lista de productos.
      // Al cerrarla, volveremos a ver la lista actualizada (si usas watch allá).
      Navigator.pop(context); 
    } else {
      // ERROR: Mostrar el mensaje de error y resetear loading
      productProvider.clearLoading();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${productProvider.errorMessage}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<CategoryProvider>();
    final products = context.watch<ProductProvider>();
    
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

              // Dropdown de categorías
              DropdownButtonFormField<int>(
                initialValue: _selectedCategoryId,
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(),
                ),
                items: categories.categories.map((cat) {
                  return DropdownMenuItem<int>(
                    value: cat.id,
                    child: Text(cat.nombre),
                  );
                }).toList(),
                onChanged: (v) => setState(() => _selectedCategoryId = v),
                validator: (v) => v == null ? 'Selecciona una categoría' : null,
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: products.isLoading ? null : saveProduct,
                child: products.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("Guardar producto"),
              ),
              if (categories.errorMessage != null)
                Text(
                  "Error: ${categories.errorMessage}",
                  style: const TextStyle(color: Colors.red),
                )
            ],
          ),
        ),
      ),
    );
  }
}

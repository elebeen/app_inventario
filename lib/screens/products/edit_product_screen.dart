import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:registro_productos/components/app_bar.dart';
import 'package:registro_productos/data/models/product_model.dart';
import 'package:registro_productos/provider/category_provider.dart';
import 'package:registro_productos/provider/product_provider.dart';

class EditProductScreen extends StatefulWidget {
  final int? id;
  const EditProductScreen({super.key, this.id});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores
  late TextEditingController _barcodeController;
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  int? _selectedCategoryId;

  bool _controllersInitialized = false;
  late ProductProvider _productProvider;

  @override
  void initState() {
    super.initState();

    _barcodeController = TextEditingController();
    _nameController = TextEditingController();
    _priceController = TextEditingController();
    _stockController = TextEditingController();

    // 1. Deferir la carga de datos de forma segura al siguiente frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);

      // Iniciar la carga de categorías
      categoryProvider.fetchCategories();

      // Iniciar la carga del producto
      if (widget.id != null) {
        productProvider.fetchProduct(widget.id!);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _productProvider = Provider.of<ProductProvider>(context, listen: false);
    
    // Inicializar controladores aquí, no en build()
    if (!_controllersInitialized && _productProvider.currentProduct != null) {
      _initializeControllers(_productProvider.currentProduct!);
    }
  }

  // Función para inicializar los controladores con los datos del producto
  void _initializeControllers(Product product) {
    // Solo inicializa la primera vez
    if (_controllersInitialized) return;

    _barcodeController.text = product.codigoBarras ?? '';
    _nameController.text = product.nombre ?? '';
    // Usamos el formato toString() para los números
    _priceController.text = product.precio?.toString() ?? '';
    _stockController.text = product.stock?.toString() ?? '';
    // Si la categoría del producto es nula, no inicializamos _selectedCategoryId
    _selectedCategoryId = product.categoria?.id;

    _controllersInitialized = true;
  }

  @override
  void dispose() {
    _barcodeController.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    // Limpiar el producto actual al salir de la pantalla
    _productProvider.clearCurrentProduct();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate() || widget.id == null) return;

    final categoryId = _selectedCategoryId;
    if (categoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona una categoría')),
      );
      return;
    }

    final productProvider = Provider.of<ProductProvider>(context, listen: false);

    final int id = widget.id!;
    final String nombre = _nameController.text;
    final double precio = double.tryParse(_priceController.text) ?? 0.0;
    final int stock = int.tryParse(_stockController.text) ?? 0;

    await productProvider.updateProduct(
      id,
      nombre,
      precio,
      stock,
      categoryId,
    );

    if (!mounted) return;

    if (productProvider.errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Producto $nombre actualizado.')),
      );
      
      // Solo resetear la paginación, no limpiar la lista de productos
      productProvider.resetPagination();
      productProvider.clearLoading();
      
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al actualizar: ${productProvider.errorMessage}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();
    final productProvider = context.watch<ProductProvider>();

    final initialProduct = productProvider.currentProduct;

    // Lógica para mostrar la carga y errores
    if (productProvider.isLoading && initialProduct == null) {
      return const Scaffold(
        appBar: CustomAppBar(title: "Cargando..."),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (initialProduct == null || widget.id == null) {
      return Scaffold(
        appBar: CustomAppBar(title: "Error"),
        body: Center(child: Text(
            productProvider.errorMessage ?? "No se encontraron datos para el ID: ${widget.id}"
        )),
      );
    }

    // Manejar errores o carga de categorías de forma más integrada
    final isCategoryDataReady = !categoryProvider.isLoading && categoryProvider.errorMessage == null;

    if (!isCategoryDataReady) {
      return Scaffold(
        appBar: CustomAppBar(title: "Editar Producto"),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (categoryProvider.isLoading)
                const CircularProgressIndicator(),
              if (categoryProvider.errorMessage != null)
                Text("Error categorías: ${categoryProvider.errorMessage}", style: const TextStyle(color: Colors.red)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(title: "Editar ${initialProduct.nombre}"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _barcodeController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Código de barras",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Nombre",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                (v == null || v.isEmpty) ? "Ingresa un nombre" : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: "Precio",
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) =>
                (v == null || v.isEmpty) ? "Ingresa un precio" : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(
                  labelText: "Stock",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (v) =>
                (v == null || v.isEmpty) ? "Ingresa el stock" : null,
              ),

              const SizedBox(height: 20),

              // Dropdown de categorías
              DropdownButtonFormField<int>(
                initialValue: _selectedCategoryId,
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(),
                ),
                items: categoryProvider.categories.map((cat) {
                  return DropdownMenuItem<int>(
                    value: cat.id,
                    child: Text(cat.nombre),
                  );
                }).toList(),
                onChanged: (v) => setState(() => _selectedCategoryId = v),
                validator: (v) => v == null ? 'Selecciona una categoría' : null,
              ),

              const SizedBox(height: 20),

              // Botón de guardar
              ElevatedButton(
                onPressed: productProvider.isLoading ? null : _saveProduct,
                child: productProvider.isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Text("Guardar Cambios"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
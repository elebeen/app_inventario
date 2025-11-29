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
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _barcodeController = TextEditingController();
    _nameController = TextEditingController();
    _priceController = TextEditingController();
    _stockController = TextEditingController();

    _productProvider = Provider.of<ProductProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);

      categoryProvider.fetchCategories();

      if (widget.id != null) {
        _productProvider.fetchProduct(widget.id!);
      }
    });
  }

  void _initializeControllers(Product product) {
    if (_controllersInitialized) return;

    _barcodeController.text = product.codigoBarras ?? '';
    _nameController.text = product.nombre ?? '';
    _priceController.text = product.precio?.toStringAsFixed(2) ?? '';
    _stockController.text = product.stock?.toString() ?? '';
    _selectedCategoryId = product.categoria?.id;

    _controllersInitialized = true;
  }

  @override
  void dispose() {
    _barcodeController.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _productProvider.clearCurrentProduct();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate() || widget.id == null) return;

    final categoryId = _selectedCategoryId;
    if (categoryId == null) {
      _showErrorSnackBar('Selecciona una categoría');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final productProvider = _productProvider;

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
        _showSuccessSnackBar('Producto "$nombre" actualizado correctamente');
        
        productProvider.resetPagination();
        productProvider.clearLoading();
        
        Navigator.pop(context, true); // Retornar true indicando éxito
      } else {
        _showErrorSnackBar('Error al actualizar: ${productProvider.errorMessage}');
      }
    } catch (error) {
      _showErrorSnackBar('Error inesperado: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green.shade100),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade100),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    bool readOnly = false,
    TextInputType? keyboardType,
    IconData? prefixIcon,
    String? hintText,
    int? maxLines = 1,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
          ),
          filled: true,
          fillColor: readOnly ? Colors.grey.shade50 : Colors.white,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 20) : null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildCategoryDropdown(CategoryProvider categoryProvider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<int>(
        initialValue: _selectedCategoryId,
        decoration: InputDecoration(
          labelText: 'Categoría',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(Icons.category, size: 20, color: Colors.grey.shade600),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
        items: categoryProvider.categories.map((cat) {
          return DropdownMenuItem<int>(
            value: cat.id,
            child: Text(
              cat.nombre,
              style: TextStyle(
                color: _selectedCategoryId == cat.id ? Colors.blue.shade600 : Colors.grey.shade800,
                fontWeight: _selectedCategoryId == cat.id ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          );
        }).toList(),
        onChanged: (v) => setState(() => _selectedCategoryId = v),
        validator: (v) => v == null ? 'Selecciona una categoría' : null,
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(12),
        icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 20),
      child: ElevatedButton(
        onPressed: _isSaving ? null : _saveProduct,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          shadowColor: Colors.blue.shade200,
        ),
        child: _isSaving
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.save, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    "GUARDAR CAMBIOS",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();
    final productProvider = context.watch<ProductProvider>();

    final initialProduct = productProvider.currentProduct;

    if (!_controllersInitialized && initialProduct != null) {
      _initializeControllers(initialProduct);
    }
    if (productProvider.isLoading && initialProduct == null) {
      return Scaffold(
        appBar: CustomAppBar(title: "Cargando..."),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
              ),
              const SizedBox(height: 16),
              Text(
                "Cargando producto...",
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (initialProduct == null || widget.id == null) {
      return Scaffold(
        appBar: CustomAppBar(title: "Error"),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
              const SizedBox(height: 16),
              Text(
                productProvider.errorMessage ?? "No se encontraron datos para el ID: ${widget.id}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back),
                label: Text("Volver"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade600,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final isCategoryDataReady = !categoryProvider.isLoading && categoryProvider.errorMessage == null;

    if (!isCategoryDataReady) {
      return Scaffold(
        appBar: CustomAppBar(title: "Editar Producto"),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (categoryProvider.isLoading) ...[
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
                ),
                const SizedBox(height: 16),
                Text(
                  "Cargando categorías...",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
              if (categoryProvider.errorMessage != null) ...[
                Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
                const SizedBox(height: 16),
                Text(
                  "Error: ${categoryProvider.errorMessage}",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red.shade600),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: "Editar Producto",
      ),
      body: Container(
        color: Colors.grey.shade50,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [

              _buildFormField(
                controller: _barcodeController,
                label: "Código de barras",
                validator: (v) => null,
                readOnly: true,
                prefixIcon: Icons.qr_code,
              ),

              _buildFormField(
                controller: _nameController,
                label: "Nombre del producto",
                validator: (v) => (v == null || v.isEmpty) ? "Ingresa un nombre" : null,
                prefixIcon: Icons.shopping_bag,
                hintText: "Ej: Laptop Dell Inspiron 15",
              ),

              Row(
                children: [
                  Expanded(
                    child: _buildFormField(
                      controller: _priceController,
                      label: "Precio",
                      validator: (v) => (v == null || v.isEmpty) ? "Ingresa un precio" : null,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      prefixIcon: Icons.attach_money,
                      hintText: "0.00",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFormField(
                      controller: _stockController,
                      label: "Stock",
                      validator: (v) => (v == null || v.isEmpty) ? "Ingresa el stock" : null,
                      keyboardType: TextInputType.number,
                      prefixIcon: Icons.inventory_2,
                      hintText: "0",
                    ),
                  ),
                ],
              ),

              _buildCategoryDropdown(categoryProvider),

              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }
}
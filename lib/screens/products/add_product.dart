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
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    barcodeController = TextEditingController(text: widget.initialBarcode);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
    });
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategoryId == null) {
      _showErrorSnackBar('Selecciona una categoría');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);

      await productProvider.createProduct(
        barcodeController.text,
        nameController.text,
        double.parse(priceController.text),
        int.parse(stockController.text),
        _selectedCategoryId!,
      );

      if (!mounted) return;

      if (productProvider.errorMessage == null) {
        _showSuccessSnackBar('Producto "${nameController.text}" creado exitosamente');
        
        productProvider.refreshProducts();
        productProvider.clearLoading();
        
        Navigator.pop(context, true); // Retornar éxito
      } else {
        _showErrorSnackBar('Error al crear: ${productProvider.errorMessage}');
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
            Icon(Icons.check_circle, color: Colors.green.shade100, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade100, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 4),
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
    String? helperText,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          helperText: helperText,
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
            borderSide: BorderSide(color: Colors.green.shade600, width: 2),
          ),
          filled: true,
          fillColor: readOnly ? Colors.grey.shade50 : Colors.white,
          prefixIcon: prefixIcon != null 
              ? Icon(prefixIcon, size: 20, color: Colors.grey.shade600)
              : null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildCategoryDropdown(CategoryProvider categoryProvider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
            borderSide: BorderSide(color: Colors.green.shade600, width: 2),
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
                color: _selectedCategoryId == cat.id ? Colors.green.shade600 : Colors.grey.shade800,
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
        hint: const Text('Selecciona una categoría'),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 20),
      child: ElevatedButton(
        onPressed: _isSaving ? null : _saveProduct,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade600,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          shadowColor: Colors.green.shade200,
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
                  Icon(Icons.add_circle, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    "CREAR PRODUCTO",
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

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade100),
      ),
      child: Row(
        children: [
          Icon(Icons.add_shopping_cart, color: Colors.green.shade600, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Nuevo Producto",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Código de barras: ${widget.initialBarcode}",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green.shade600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorSection(CategoryProvider categoryProvider) {
    if (categoryProvider.errorMessage != null) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade600, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "Error cargando categorías: ${categoryProvider.errorMessage}",
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();

    return Scaffold(
      appBar: CustomAppBar(
        title: "Agregar Producto",
      ),
      body: Container(
        color: Colors.grey.shade50,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildHeader(),

              _buildFormField(
                controller: barcodeController,
                label: "Código de barras",
                validator: (v) => null,
                readOnly: true,
                prefixIcon: Icons.qr_code,
                helperText: "Este campo se completa automáticamente",
              ),

              _buildFormField(
                controller: nameController,
                label: "Nombre del producto",
                validator: (v) => (v == null || v.isEmpty) ? "Ingresa un nombre" : null,
                prefixIcon: Icons.shopping_bag,
                hintText: "Ej: Laptop Dell Inspiron 15",
              ),

              Row(
                children: [
                  Expanded(
                    child: _buildFormField(
                      controller: priceController,
                      label: "Precio",
                      validator: (v) => (v == null || v.isEmpty) ? "Ingresa un precio" : null,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      prefixIcon: Icons.attach_money,
                      hintText: "0.00",
                      helperText: "El precio debe ser mayor a 0",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFormField(
                      controller: stockController,
                      label: "Stock inicial",
                      validator: (v) => (v == null || v.isEmpty) ? "Ingresa el stock" : null,
                      keyboardType: TextInputType.number,
                      prefixIcon: Icons.inventory_2,
                      hintText: "0",
                      helperText: "Cantidad disponible",
                    ),
                  ),
                ],
              ),

              _buildErrorSection(categoryProvider),

              _buildCategoryDropdown(categoryProvider),

              if (categoryProvider.isLoading)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade100),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Cargando categorías...",
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    barcodeController.dispose();
    nameController.dispose();
    priceController.dispose();
    stockController.dispose();
    super.dispose();
  }
}
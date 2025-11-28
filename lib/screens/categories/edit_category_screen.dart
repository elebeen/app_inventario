import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:registro_productos/components/app_bar.dart';
import 'package:registro_productos/provider/category_provider.dart';

class EditCategoryScreen extends StatefulWidget {
  final int? id;
  final String? name;
  const EditCategoryScreen({super.key, this.id, this.name});

  @override
  State<EditCategoryScreen> createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _categoriaCtrl = TextEditingController();
  final FocusNode _categoryFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _categoriaCtrl.text = widget.name ?? '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Provider.of<CategoryProvider>(context, listen: false);
      
      // Auto-focus en el campo de texto
      FocusScope.of(context).requestFocus(_categoryFocusNode);
    });
  }

  Future<void> _updateCategory() async {
    if (!_formKey.currentState!.validate()) return;

    // Ocultar teclado al enviar formulario
    FocusScope.of(context).unfocus();

    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    await categoryProvider.updateCategory(widget.id!, _categoriaCtrl.text.trim());

    if (!mounted) return;

    if (categoryProvider.errorMessage == null) {
      _showSuccessMessage();
      _navigateBack(categoryProvider);
    } else {
      _showErrorMessage(categoryProvider.errorMessage!);
    }
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Categoría actualizada correctamente'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _navigateBack(CategoryProvider categoryProvider) {
    Navigator.pop(context);
    categoryProvider.resetCategories();
    categoryProvider.fetchCategories();
  }

  void _onCancel() {
    FocusScope.of(context).unfocus();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _categoriaCtrl.dispose();
    _categoryFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();

    return Scaffold(
      appBar: CustomAppBar(title: widget.id == null ? 'Nueva Categoría' : 'Editando Categoría'),
      body: categoryProvider.isLoading 
          ? _buildLoadingState()
          : _buildForm(categoryProvider),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Cargando...', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildForm(CategoryProvider categoryProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderInfo(),
          const SizedBox(height: 32),
          _buildCategoryForm(categoryProvider),
        ],
      ),
    );
  }

  Widget _buildHeaderInfo() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.id == null ? 'Nueva Categoría' : 'Editando Categoría',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.id == null 
                        ? 'Complete los datos para crear una nueva categoría'
                        : 'Modifique los datos de la categoría existente',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryForm(CategoryProvider categoryProvider) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Campo de nombre de categoría
          Text(
            'Nombre de la Categoría',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _categoriaCtrl,
            focusNode: _categoryFocusNode,
            decoration: InputDecoration(
              labelText: 'Ej: Electrónicos, Ropa, Hogar...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.category_outlined),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            style: const TextStyle(fontSize: 16),
            textCapitalization: TextCapitalization.words,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese un nombre para la categoría';
              }
              if (value.length < 2) {
                return 'El nombre debe tener al menos 2 caracteres';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          
          // Información de ID (solo para edición)
          if (widget.id != null) _buildCategoryIdInfo(),
          
          const SizedBox(height: 32),
          
          // Botones de acción
          _buildActionButtons(categoryProvider),
          
          // Mensaje de error
          if (categoryProvider.errorMessage != null) 
            _buildErrorWidget(categoryProvider.errorMessage!),
        ],
      ),
    );
  }

  Widget _buildCategoryIdInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300] ?? Colors.grey),
      ),
      child: Row(
        children: [
          Icon(
            Icons.fingerprint_outlined,
            color: Colors.grey[600],
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ID de Categoría',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.id.toString(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(CategoryProvider categoryProvider) {
    return Row(
      children: [
        // Botón Cancelar
        Expanded(
          child: OutlinedButton(
            onPressed: categoryProvider.isLoading ? null : _onCancel,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Cancelar',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        const SizedBox(width: 16),
        
        // Botón Guardar
        Expanded(
          child: ElevatedButton(
            onPressed: categoryProvider.isLoading ? null : _updateCategory,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: categoryProvider.isLoading
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
                      const Icon(Icons.save_outlined, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Guardar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorWidget(String errorMessage) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red[200] ?? Colors.red),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red[600],
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              errorMessage,
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
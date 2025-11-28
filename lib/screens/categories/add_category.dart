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
  final FocusNode _categoryFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      // Auto-focus en el campo de texto
      FocusScope.of(context).requestFocus(_categoryFocusNode);
    });
  }

  Future<void> _guardarCategoria() async {
    if (!_formKey.currentState!.validate()) return;

    // Ocultar teclado al enviar formulario
    FocusScope.of(context).unfocus();

    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    await categoryProvider.createCategory(_categoriaCtrl.text.trim());

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
            Text('Categoría creada correctamente'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
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
        duration: const Duration(seconds: 4),
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
      appBar: CustomAppBar(title: 'Nueva Categoría'),
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
          Text('Creando categoría...', style: TextStyle(fontSize: 16)),
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
          _buildWelcomeCard(),
          const SizedBox(height: 32),
          _buildCategoryForm(categoryProvider),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(
              Icons.add_circle_outline,
              color: Theme.of(context).colorScheme.primary,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nueva Categoría',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Complete la información para crear una nueva categoría en el sistema. Las categorías ayudan a organizar y clasificar los productos.',
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
            'Nombre de la Categoría *',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ingrese un nombre descriptivo para la categoría',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _categoriaCtrl,
            focusNode: _categoryFocusNode,
            decoration: InputDecoration(
              labelText: 'Ej: Electrónicos, Ropa, Hogar, Deportes...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.category_outlined),
              suffixIcon: _categoriaCtrl.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: () {
                        _categoriaCtrl.clear();
                        setState(() {});
                      },
                    )
                  : null,
              filled: true,
              fillColor: Colors.grey[50],
            ),
            style: const TextStyle(fontSize: 16),
            textCapitalization: TextCapitalization.words,
            onChanged: (value) => setState(() {}),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese un nombre para la categoría';
              }
              if (value.length < 2) {
                return 'El nombre debe tener al menos 2 caracteres';
              }
              if (value.length > 50) {
                return 'El nombre no puede exceder los 50 caracteres';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: Colors.grey[500],
              ),
              const SizedBox(width: 6),
              Text(
                '${_categoriaCtrl.text.length}/50 caracteres',
                style: TextStyle(
                  fontSize: 12,
                  color: _categoriaCtrl.text.length > 50 ? Colors.red : Colors.grey[600],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Ejemplos de categorías
          _buildExamplesCard(),
          
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

  Widget _buildExamplesCard() {
    final examples = [
      'Electrónicos',
      'Ropa y Accesorios',
      'Hogar y Jardín',
      'Deportes',
      'Libros',
      'Juguetes',
      'Salud y Belleza'
    ];

    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: Colors.blue[700],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Ideas de categorías',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Algunos ejemplos de categorías comunes:',
              style: TextStyle(
                color: Colors.blue[700],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: examples.map((example) {
                return GestureDetector(
                  onTap: () {
                    _categoriaCtrl.text = example;
                    setState(() {});
                  },
                  child: Chip(
                    label: Text(example),
                    backgroundColor: Colors.blue[100],
                    labelStyle: TextStyle(
                      color: Colors.blue[800],
                      fontSize: 12,
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(CategoryProvider categoryProvider) {
    return Column(
      children: [
        // Botón Principal - Crear Categoría
        ElevatedButton(
          onPressed: categoryProvider.isLoading ? null : _guardarCategoria,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
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
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_circle_outline, size: 20),
                  SizedBox(width: 12),
                  Text(
                    'Crear Categoría',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
        ),
        
        const SizedBox(height: 12),
        
        // Botón Secundario - Cancelar
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: categoryProvider.isLoading ? null : _onCancel,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(color: Colors.grey[400]!),
            ),
            child: const Text(
              'Cancelar',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        )
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Error al crear categoría',
                  style: TextStyle(
                    color: Colors.red[700],
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  errorMessage,
                  style: TextStyle(
                    color: Colors.red[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
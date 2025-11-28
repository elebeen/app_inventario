import 'package:provider/provider.dart';
import 'package:registro_productos/provider/auth_provider.dart';
import 'package:registro_productos/screens/categories/categories_screen.dart';
import 'package:registro_productos/screens/products/products_screen.dart';
import 'package:registro_productos/screens/users/users_screen.dart';
import 'package:registro_productos/screens/account/account.dart';
import 'package:registro_productos/components/bottom_bar.dart';
import 'package:registro_productos/components/app_bar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Lógica de navegación basada en índices fijos (ProductScreen en index 0, etc.)
  static const Map<String, int> _pageIndices = {
    'Productos': 0,
    'Categorías': 1,
    'Usuarios': 2,
    'Cuenta': 3,
  };
  
  // Lista fija de todas las páginas posibles
  static const List<Widget> _allPages = <Widget>[
    ProductScreen(), // 0. Productos
    CategoryScreen(), // 1. Categorías
    UserScreen(), // 2. Usuarios
    AccountScreen(), // 3. Account
  ];
  
  // Función para obtener la configuración de la barra de navegación basada en roles
  List<Map<String, dynamic>> _getNavConfig(BuildContext context) {
    // Necesitas acceder al AuthProvider para saber los roles.
    final auth = Provider.of<AuthProvider>(context, listen: false); 
    final roles = auth.user?['roles'] ?? [];
    final isAdmin = roles.contains('admin_tienda') || roles.contains('admin_tienda_secundario');
    final isEmployee = roles.contains('empleado_tienda');
    
    // Configuración para Administrador (4 ítems)
    if (isAdmin) {
      return [
        {'label': 'Productos', 'icon': Icons.inventory_2, 'index': _pageIndices['Productos']!},
        {'label': 'Categorías', 'icon': Icons.category, 'index': _pageIndices['Categorías']!},
        {'label': 'Usuarios', 'icon': Icons.people, 'index': _pageIndices['Usuarios']!},
        {'label': 'Cuenta', 'icon': Icons.account_circle_outlined, 'index': _pageIndices['Cuenta']!},
      ];
    // Configuración para Empleado (3 ítems)
    } else if (isEmployee) {
      return [
        {'label': 'Productos', 'icon': Icons.inventory_2, 'index': _pageIndices['Productos']!},
        {'label': 'Categorías', 'icon': Icons.category, 'index': _pageIndices['Categorías']!},
        {'label': 'Cuenta', 'icon': Icons.account_circle_outlined, 'index': _pageIndices['Cuenta']!},
      ];
    // Configuración por defecto / Error (2 ítems - No tienen página real asociada)
    } else {
      return [
        {'label': 'Error de inicio de sesion', 'icon': Icons.error_outline, 'index': 0},
        {'label': 'Error de inicio de sesion', 'icon': Icons.error_outline, 'index': 1},
      ];
    }
  }

  void _onItemTapped(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    // 1. OBTENER LA CONFIGURACIÓN DE NAVEGACIÓN ACTUAL
    final navConfig = _getNavConfig(context);
    
    // 2. CORREGIR el currentIndex
    // Si el índice actual (por ejemplo, 3) es mayor o igual que el nuevo número de ítems (por ejemplo, 3), 
    // lo reseteamos a 0.
    if (_currentIndex >= navConfig.length) {
      _currentIndex = 0;
    }
    
    // 3. Obtener el índice real de la página que queremos mostrar
    // Cuando el usuario es Admin, index 0 en la barra es index 0 en _allPages.
    // Cuando hay error, no se usa este mapeo. 
    final int pageIndexToShow = navConfig[_currentIndex]['index'];

    return Scaffold(
      appBar: CustomAppBar(
        title: navConfig[_currentIndex]['label'] // Usar la etiqueta del ítem actual
      ),
      // Mostrar la página real usando el índice del ítem seleccionado
      body: _allPages[pageIndexToShow],
      
      // Pasar la configuración corregida y el índice corregido al BottomBar
      bottomNavigationBar: CustomBottomBar(
        // Le pasamos el índice corregido (0, 1, 2, o 3)
        currentIndex: _currentIndex, 
        onTap: _onItemTapped, 
        navConfig: navConfig,
        // (Opcional) Debes actualizar CustomBottomBar para recibir `navConfig` 
        // y generar los BottomNavigationBarItems a partir de esta lista.
        // Si no quieres cambiar CustomBottomBar, tendrás que replicar la lógica 
        // de generación de ítems en el padre.
      )
    );
  }
}
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

  static const List<String> _pageTitles = [
    'Productos',
    'Categorías',
    'Usuarios',
    'Configuración',
  ];

  static const List<Widget> _pages = <Widget>[
    ProductScreen(), // 0. Productos (Usando tu InventoryScreen)
    CategoryScreen(), // 1. Categorías
    UserScreen(), // 2. Usuarios
    AccountScreen(), // 3. Account (Pantalla de ejemplo abajo)
  ];

  void _onItemTapped(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: _pageTitles[_currentIndex]
      ),
      body: _pages.elementAt(_currentIndex),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      )
    );
  }
}

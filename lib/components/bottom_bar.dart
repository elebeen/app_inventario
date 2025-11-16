import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:registro_productos/provider/auth_provider.dart';

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final roles = auth.user?['roles'] ?? [];

    final isAdmin = roles.contains('admin_tienda') ||
        roles.contains('admin_tienda_secundario');
        
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: Colors.white,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: [
        if (isAdmin) ...[
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: 'Productos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categorías',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Usuarios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ] else ...[
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: 'Productos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categorías',
          ),
        ],
      ],
    );
  }
}

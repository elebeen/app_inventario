import 'package:flutter/material.dart';

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  // ¡NUEVO! Recibe la configuración calculada del padre
  final List<Map<String, dynamic>> navConfig; 

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.navConfig, // <-- AÑADIR AQUI
  });

  @override
  Widget build(BuildContext context) {
    // Mapear la configuración a BottomNavigationBarItems
    final items = navConfig.map((item) {
      return BottomNavigationBarItem(
        icon: Icon(item['icon']), // Usar el ícono del mapa
        label: item['label'], // Usar la etiqueta del mapa
      );
    }).toList();
        
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      // ... (Otros estilos)
      type: BottomNavigationBarType.fixed,
      items: items, // Usar la lista generada
    );
  }
}
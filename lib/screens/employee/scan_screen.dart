import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'new_product_screen.dart';
import '../admin/update_stock_screen.dart';
import '../../data/inventory_data.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final MobileScannerController controller = MobileScannerController();
  bool isScanned = false;

  void _onDetect(String code) {
    if (isScanned) return;
    isScanned = true;

    // Buscar si ya existe
    final existingIndex = inventario.indexWhere((p) => p['codigo'] == code);

    if (existingIndex == -1) {
      // Producto nuevo
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => NewProductScreen(codigo: code),
        ),
      );
    } else {
      // Producto existente → actualizar stock
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => UpdateStockScreen(index: existingIndex),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Escanear Producto")),
      body: MobileScanner(
        controller: controller,
        onDetect: (barcode) {
          final code = barcode.barcodes.first.rawValue ?? '';
          if (code.isNotEmpty) _onDetect(code);
        },
      ),
    );
  }
}

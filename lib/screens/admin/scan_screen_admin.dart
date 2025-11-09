import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'new_product_admin_screen.dart';
import 'update_stock_screen.dart';
import '../../data/inventory_data.dart';

class ScanScreenAdmin extends StatefulWidget {
  const ScanScreenAdmin({super.key});

  @override
  State<ScanScreenAdmin> createState() => _ScanScreenAdminState();
}

class _ScanScreenAdminState extends State<ScanScreenAdmin> {
  final MobileScannerController controller = MobileScannerController();
  bool isScanned = false;

  void _onDetect(String code) {
    if (isScanned) return;
    isScanned = true;

    final existingIndex = inventario.indexWhere((p) => p['codigo'] == code);

    if (existingIndex == -1) {
      // Producto nuevo → versión admin
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => NewProductAdminScreen(codigo: code),
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
      appBar: AppBar(title: const Text("Escanear Producto (Admin)")),
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

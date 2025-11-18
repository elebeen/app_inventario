import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:registro_productos/components/app_bar.dart';
import 'package:registro_productos/screens/products/add_product.dart';

class ScanProductScreen extends StatefulWidget {
  const ScanProductScreen({super.key});

  @override
  State<ScanProductScreen> createState() => _ScanProductScreenState();
}

class _ScanProductScreenState extends State<ScanProductScreen> {
  bool scanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Escanear producto"),
      body: SizedBox.expand(
        child: MobileScanner(
          fit: BoxFit.cover, // ← opcional para que llene el espacio
          onDetect: (capture) {
            if (scanned) return;
            scanned = true;

            final barcode = capture.barcodes.first;
            final code = barcode.rawValue;

            if (code != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => AddProductScreen(initialBarcode: code),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:registro_productos/components/app_bar.dart';
import 'package:registro_productos/provider/product_provider.dart';
import 'package:registro_productos/screens/products/add_product.dart';
import 'package:registro_productos/screens/products/product_detail_screen.dart';

class ScanProductScreen extends StatefulWidget {
  const ScanProductScreen({super.key});

  @override
  State<ScanProductScreen> createState() => _ScanProductScreenState();
}

class _ScanProductScreenState extends State<ScanProductScreen> {
  bool scanned = false;
  bool _isProcessing = false; 

  @override
  void dispose() {
    scanned = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Usamos el Provider solo dentro del método onDetect, por eso no es necesario
    // usar Consumer, pero sí necesitamos la instancia.

    return Scaffold(
      appBar: CustomAppBar(title: "Escanear producto"),
      body: SizedBox.expand(
        child: MobileScanner(
          fit: BoxFit.cover, // ← opcional para que llene el espacio
          onDetect: (capture) async {
            if (_isProcessing) return;

            final barcode = capture.barcodes.first;
            final code = barcode.rawValue;

            if (code == null) return;

            setState(() {
              _isProcessing = true;
            });

            final api = Provider.of<ProductProvider>(context, listen: false);

            final dynamic exists = await api.scanProduct(code);

            if (exists != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(product: exists),
                ),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => AddProductScreen(initialBarcode: code), // Pasa el código de barras
                ),
              );
            }

            // Nota: El isProcessing se restablecerá si el usuario vuelve a esta pantalla 
            // y se vuelve a montar el widget (se llama a initState o se presiona back).
          },
        ),
      ),
    );
  }
}
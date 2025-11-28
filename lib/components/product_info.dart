import 'package:flutter/material.dart';
import 'package:registro_productos/data/models/product_model.dart';

class ProductInfo extends StatelessWidget {
  final Product product;

  const ProductInfo({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con código de barras
          _buildInfoRow(
            icon: Icons.qr_code,
            label: 'Código de Barras',
            value: product.codigoBarras?? '',
            isImportant: true,
          ),
          
          const SizedBox(height: 16),
          
          // Nombre del producto
          Text(
            product.nombre?? '',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: 16),
          
          // Información de precio y stock en fila
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.attach_money,
                  label: 'Precio',
                  value: '\$${product.precio?.toStringAsFixed(2)}',
                  valueColor: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.inventory_2,
                  label: 'Stock',
                  value: product.stock.toString(),
                  valueColor: product.stock! > 0 ? Colors.blue : Colors.red,
                  showWarning: product.stock! <= 10,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Categoría
          _buildInfoRow(
            icon: Icons.category,
            label: 'Categoría',
            value: product.categoria?.nombre ?? 'Sin categoría',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool isImportant = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: isImportant ? 16 : 14,
                  fontWeight: isImportant ? FontWeight.bold : FontWeight.w500,
                  color: isImportant ? Colors.blueGrey : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color valueColor,
    bool showWarning = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: showWarning ? Colors.orange.withValues(alpha: 0.3) : Colors.grey[200]!,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.5),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: showWarning ? Colors.orange : Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: showWarning ? Colors.orange : Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (showWarning) ...[
                const SizedBox(width: 4),
                const Icon(Icons.warning_amber, size: 12, color: Colors.orange),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
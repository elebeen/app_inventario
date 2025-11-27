import 'package:flutter/material.dart';

class RoleBadge extends StatelessWidget {
  final String role;
  
  const RoleBadge({
    super.key,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: _getRoleColor(role).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getRoleColor(role).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getRoleIcon(role),
            size: 16,
            color: _getRoleColor(role),
          ),
          const SizedBox(width: 6),
          Text(
            _formatRole(role),
            style: TextStyle(
              color: _getRoleColor(role),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  String _formatRole(String role) {
    switch (role) {
      case 'admin_tienda':
        return 'Administrador de Tienda';
      case 'admin_tienda_secundario':
        return 'Administrador Secundario';
      case 'empleado_tienda':
        return 'Empleado de Tienda';
      default:
        return role;
    }
  }

  IconData _getRoleIcon(String role) {
    switch (role) {
      case 'admin_tienda':
        return Icons.admin_panel_settings;
      case 'admin_tienda_secundario':
        return Icons.manage_accounts;
      case 'empleado_tienda':
        return Icons.badge;
      default:
        return Icons.person;
    }
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'admin_tienda':
        return Colors.red;
      case 'admin_tienda_secundario':
        return Colors.orange;
      case 'empleado_tienda':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
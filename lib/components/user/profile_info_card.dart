import 'package:flutter/material.dart';
import 'info_row.dart';
import 'role_badge.dart';

class ProfileInfoCard extends StatelessWidget {
  final String name;
  final String email;
  final String role;
  
  const ProfileInfoCard({
    super.key,
    required this.name,
    required this.email,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Información del Perfil',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            InfoRow(
              icon: Icons.person_outline,
              title: 'Nombre de usuario',
              value: name.isNotEmpty ? name : 'No disponible',
            ),
            
            const SizedBox(height: 12),
            
            InfoRow(
              icon: Icons.email_outlined,
              title: 'Correo electrónico',
              value: email,
            ),
            
            const SizedBox(height: 12),
            
            // Información del rol
            Row(
              children: [
                Icon(
                  Icons.work_outline,
                  color: Colors.grey[600],
                  size: 24,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rol',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      RoleBadge(role: role),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
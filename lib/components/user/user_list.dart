import 'package:flutter/material.dart';
import 'package:registro_productos/components/user/info_row.dart';
import 'package:registro_productos/components/user/role_badge.dart';
import 'package:registro_productos/data/models/user_model.dart';

class UserList extends StatelessWidget {
  final List<User> users;
  final ScrollController scrollController;
  final bool hasMore;
  final bool isLoading;

  const UserList(
    this.users,
    this.scrollController,
    this.hasMore,
    this.isLoading, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: users.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == users.length) {
          return _buildLoadingIndicator();
        }

        final user = users[index];

        return _buildUserCard(context, user);
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildUserCard(BuildContext context, User user) {
    final userName = user.email.split('@')[0];
    final userStatus = user.activo ? 'Activo' : 'Inactivo';
    final statusColor = user.activo ? Colors.green : Colors.red;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con nombre y estado
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    userName,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    userStatus,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Información del usuario
            InfoRow(
              icon: Icons.email_outlined,
              title: 'Correo electrónico',
              value: user.email,
            ),
            
            const SizedBox(height: 8),
            
            // Rol del usuario
            Row(
              children: [
                Icon(
                  Icons.work_outline,
                  color: Colors.grey[600],
                  size: 20,
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
                      RoleBadge(role: user.roles.isNotEmpty ? user.roles[0].nombre : ''),
                    ],
                  ),
                ),
                //se hara si se necesita
                // Align(
                //   alignment: Alignment.centerRight,
                //   child: ElevatedButton.icon(
                //     onPressed: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => UserDetailScreen(user: user)
                //         ),
                //       );
                //     },
                //     icon: const Icon(Icons.edit, size: 16),
                //     label: const Text('Editar'),
                //     style: ElevatedButton.styleFrom(
                //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                //     ),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
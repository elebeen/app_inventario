import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:registro_productos/provider/auth_provider.dart';
import 'package:registro_productos/components/user/account_option_tile.dart';
import 'package:registro_productos/components/user/profile_info_card.dart';
import 'package:registro_productos/components/user/user_header.dart';
import 'package:registro_productos/components/utils/dialog.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;
    final name = (user?['email'] ?? '').toString().split('@')[0];
    final email = user?['email'] ?? '';
    final rol = user?['roles'][0] ?? '';

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            UserHeader(name: name, email: email),
            
            const SizedBox(height: 24),
            
            ProfileInfoCard(
              name: name,
              email: email,
              role: rol,
            ),
            
            const SizedBox(height: 24),
            
            // Opciones de la cuenta
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  AccountOptionTile(
                    icon: Icons.settings_outlined,
                    title: 'Configuración',
                    onTap: () {
                      // Navegar a configuración
                    },
                  ),
                  const Divider(height: 1),
                  AccountOptionTile(
                    icon: Icons.help_outline,
                    title: 'Ayuda y Soporte',
                    onTap: () {
                      // Navegar a ayuda
                    },
                  ),
                  const Divider(height: 1),
                  AccountOptionTile(
                    icon: Icons.logout,
                    title: 'Cerrar sesión',
                    iconColor: Theme.of(context).colorScheme.error,
                    textColor: Theme.of(context).colorScheme.error,
                    showTrailingIcon: false,
                    onTap: () {
                      DialogUtils.showLogoutDialog(context, auth.logout);
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
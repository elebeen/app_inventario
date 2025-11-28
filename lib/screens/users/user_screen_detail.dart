import 'package:flutter/material.dart';
import 'package:registro_productos/components/app_bar.dart';
import 'package:registro_productos/components/user/user_info.dart';
import 'package:registro_productos/data/models/user_model.dart';

class UserDetailScreen extends StatelessWidget {
  final User user;

  const UserDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: user.email),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔥 Aquí insertamos el nuevo widget reusado
            UserInfo(user: user),

            const Spacer(),

            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Editar pendiente')),
                    );
                  },
                  child: const Text('Editar'),
                ),
                const SizedBox(width: 12),

                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Eliminar pendiente')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Eliminar'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

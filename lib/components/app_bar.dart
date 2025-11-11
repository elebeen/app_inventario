import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:registro_productos/provider/auth_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final bool centerTitle;
  final double? titleSpacing;

  const CustomAppBar({
    super.key,
    this.title,
    this.actions,
    this.centerTitle = false,
    this.titleSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;
    final name = (user?['email'] ?? '').toString().split('@')[0];

    return AppBar(
      title: Text(
        title ?? name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      backgroundColor: Colors.blueAccent,
      elevation: 3,
      centerTitle: centerTitle,
      titleSpacing: titleSpacing,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

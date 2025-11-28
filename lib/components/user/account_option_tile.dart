import 'package:flutter/material.dart';

class AccountOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? textColor;
  final bool showTrailingIcon;
  
  const AccountOptionTile({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.iconColor,
    this.textColor,
    this.showTrailingIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? Theme.of(context).colorScheme.onSurface,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Theme.of(context).colorScheme.onSurface,
        ),
      ),
      trailing: showTrailingIcon 
          ? const Icon(Icons.arrow_forward_ios_rounded, size: 16)
          : null,
      onTap: onTap,
    );
  }
}
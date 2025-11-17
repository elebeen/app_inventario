import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:registro_productos/components/user.dart';
import '../../provider/user_provider.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Llamar a la API una sola vez
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).fetchUsers();
    });

    // Scroll infinito
    _scrollController.addListener(() {
      final provider = Provider.of<UserProvider>(context, listen: false);

      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.9 &&
          provider.hasMore&&
          !provider.isLoading) {
        provider.fetchUsers();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    if (userProvider.isLoading && userProvider.userResponse.content.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (userProvider.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Error: ${userProvider.errorMessage}"),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                userProvider.clearError();
                userProvider.fetchUsers();
              },
              child: const Text("Reintentar"),
            ),
          ],
        ),
      );
    }

    if (userProvider.userResponse.content.isEmpty && !userProvider.isLoading) {
      return const Center(child: Text("No se encontraron categorías."));
    }

    return UserList(
      userProvider.userResponse.content,
      _scrollController,
      userProvider.hasMore,
      userProvider.isLoading,
    );
  }
}
import 'package:flutter/material.dart';
import 'package:registro_productos/data/models/user_model.dart';
import 'package:registro_productos/screens/users/user_screen_detail.dart';

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
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final user = users[index];

        return ListTile(
          title: Text(user.email.split('@')[0]),
          subtitle: Text("ID: ${user.id}"),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UserDetailScreen(user: user)
              ),
            );
          },
        );
      },
    );
  }
}

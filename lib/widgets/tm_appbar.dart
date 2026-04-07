import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/auth_provider.dart';
import '../screens/login_screen.dart';
import '../screens/update_profile_screen.dart';

class TmAppbar extends StatelessWidget implements PreferredSize {
  const TmAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final userModel = authProvider.userModel;
        final profilePic = userModel?.photo ?? '';
        final firstName = userModel?.firstName ?? '';
        final lastName = userModel?.lastName ?? '';
        final email = userModel?.email ?? '';

        return AppBar(
          backgroundColor: Colors.green,
          title: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UpdateProfileScreen()));
            },
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: profilePic.startsWith('http')
                      ? NetworkImage(profilePic) as ImageProvider
                      : profilePic.isNotEmpty
                          ? MemoryImage(
                                  base64Decode(profilePic.split(',').last))
                              as ImageProvider
                          : null,
                  child:
                      profilePic.isEmpty ? const Icon(Icons.person) : null,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$firstName  $lastName',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        email,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                await authProvider.cleanUserData();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                }
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget get child => throw UnimplementedError();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

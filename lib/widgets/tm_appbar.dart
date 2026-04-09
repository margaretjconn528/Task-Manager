import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/auth_provider.dart';
import '../screens/login_screen.dart';
import '../screens/update_profile_screen.dart';

/// Custom AppBar widget for Task Manager application.
///
/// Displays:
/// - User profile picture
/// - Name and email
/// - Logout button
///
/// Also allows navigation to profile update screen.
class TmAppbar extends StatelessWidget implements PreferredSizeWidget {
  const TmAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    /// Consumer listens to AuthProvider for real-time UI updates
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        /// Extract user data safely
        final userModel = authProvider.userModel;
        final profilePic = userModel?.photo ?? '';
        final firstName = userModel?.firstName ?? '';
        final lastName = userModel?.lastName ?? '';
        final email = userModel?.email ?? '';

        return AppBar(
          backgroundColor: Colors.green,

          /// Tapping title navigates to profile update screen
          title: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UpdateProfileScreen(),
                ),
              );
            },

            child: Row(
              children: [
                /// User profile avatar
                CircleAvatar(
                  radius: 25,

                  /// Handles 3 cases:
                  /// 1. Network image (URL)
                  /// 2. Base64 image
                  /// 3. Default icon
                  backgroundImage: profilePic.startsWith('http')
                      ? NetworkImage(profilePic) as ImageProvider
                      : profilePic.isNotEmpty
                          ? MemoryImage(
                              base64Decode(profilePic.split(',').last),
                            ) as ImageProvider
                          : null,

                  /// Default icon when no image is available
                  child: profilePic.isEmpty
                      ? const Icon(Icons.person)
                      : null,
                ),

                const SizedBox(width: 10),

                /// User name and email
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Full name
                      Text(
                        '$firstName $lastName',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),

                      /// Email address
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

          /// Logout action button
          actions: [
            IconButton(
              onPressed: () async {
                /// Clear user session data
                await authProvider.cleanUserData();

                /// Navigate to login screen and remove all previous routes
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
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

  /// Defines the preferred size of the AppBar
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
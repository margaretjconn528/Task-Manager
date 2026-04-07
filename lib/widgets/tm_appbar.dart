import 'package:flutter/material.dart';
import 'package:task_manager/Controller/auth_controller.dart';
import '../screens/login_screen.dart';

import '../screens/update_profile_screen.dart';

class TmAppbar extends StatelessWidget implements PreferredSize {
  const TmAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final profilePic = AuthController.userModel!.photo;

    return AppBar(
      backgroundColor: Colors.green,
      title: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>UpdateProfileScreen()));
        },
        child: Row(
          children: [
            CircleAvatar(
              radius:25,
              backgroundImage: NetworkImage(
                  profilePic

              ),
            ),
            SizedBox(width: 10,),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${AuthController.userModel!.firstName}  ${AuthController.userModel!.lastName}',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Colors.white
                  ),
                  overflow: TextOverflow.ellipsis,
                  ),
                  Text(AuthController.userModel!.email,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Colors.white
                  ),
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
            await AuthController.cleanUserData();
            if (context.mounted) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
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
  }

  @override
  // TODO: implement child
  Widget get child => throw UnimplementedError();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

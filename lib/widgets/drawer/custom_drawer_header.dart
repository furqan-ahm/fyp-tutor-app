import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_app/constants/colors.dart';
import 'package:tutor_app/providers/auth_provider.dart';
import 'package:tutor_app/theme.dart';

import '../../models/user_model.dart';

class CustomDrawerHeader extends StatelessWidget {
  const CustomDrawerHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppUser user = Provider.of<AuthProvider>(context).currentUser;

    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [primaryColor, accentColor],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight)),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 45.0,
            child: CircleAvatar(
                radius: 43,
                backgroundColor: primaryColor,
                foregroundImage:
                   NetworkImage(user.getProfilePictureURL),
                //NetworkImage(userImage),
                onForegroundImageError: (object, stackTrace) {
                  debugPrint('$object $stackTrace');
                  //handle image error here.
                }
                //default image here.
                // backgroundImage: ,
                ),
          ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:8.0),
            child: Column(
              children: [
                Text(
                  user.name,
                  style:
                      theme.textTheme.headlineMedium?.copyWith(color: Colors.white),
                ),

              ],
            ),
          )
        ],
      ),
    );
  }
}

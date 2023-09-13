import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tutor_app/models/user_model.dart';
import 'package:tutor_app/screens/common/edit_profile_screen.dart';

import '../../../constants/colors.dart';
import '../../../providers/auth_provider.dart';
import '../../../theme.dart';
import '../../../widgets/common/custom_appbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AppUser get user => Provider.of<AuthProvider>(context).currentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const CustomAppBar(
            title: '',
            backgroundColor: Colors.transparent,
            canPop: false,
            centerTitle: true,
          ),
          Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: primaryColor),
            child: CircleAvatar(
              backgroundColor: primaryColor,
              radius: 52,
              backgroundImage: NetworkImage(
                user.getProfilePictureURL,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            user.name,
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Text(user.email, style: GoogleFonts.montserrat(fontSize: 15)),
          const Divider(
            height: 24,
            thickness: 3,
            color: greyButtonColor,
          ),
          ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder:(context) => const EditProfileScreen(),));
            },
            leading: const Icon(
              IconsaxOutline.profile_circle,
              color: primaryColor,
            ),
            title: Text(
              'My Profile',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(
              IconsaxOutline.card_edit,
              color: primaryColor,
            ),
            title: Text(
              'Edit Education Details',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(
              IconsaxOutline.money_2,
              color: primaryColor,
            ),
            title: Text(
              'Billing',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
          ),
          // ListTile(
          //   onTap: (){},
          //   leading: const Icon(IconsaxOutline.message_question, color: primaryColor,),
          //   title: Text('Help Center', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),),
          //   trailing: const Icon(Icons.arrow_forward_ios_rounded),
          // ),
          ListTile(
            onTap: () {},
            leading: const Icon(
              IconsaxOutline.people,
              color: primaryColor,
            ),
            title: Text(
              'Invite Friends',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../widgets/common/custom_appbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({ Key? key }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const CustomAppBar(
            title: 'Profile',
            backgroundColor: Colors.transparent,
            canPop: false,
            centerTitle: true,
          ),
        ],
      ),
    );
  }
}
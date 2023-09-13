//import 'package:Bottom_boigationBtom_navigation_bar/Bottom_boigationBtom_navigation_bar.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tutor_app/constants/colors.dart';
import 'package:tutor_app/screens/student/assignment/assignments_screen.dart';
import 'package:tutor_app/screens/student/home_screen.dart';
import 'package:tutor_app/screens/student/tutors/tutor_screen.dart';
import 'package:tutor_app/screens/tutor/inbox/inbox_screen.dart';
import 'package:tutor_app/screens/student/profile/profile_screen.dart';
import 'package:tutor_app/screens/tutor/students/students_screen.dart';
import 'package:tutor_app/widgets/drawer/custom_drawer_header.dart';

import '../../providers/auth_provider.dart';
import '../../widgets/drawer/drawer_item.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({Key? key}) : super(key: key);

  @override
  _StudentDashboardScreenState createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  int currentIndex = 2;

  static const List<Widget> screens = [
    InboxScreen(),
    TutorsScreen(),
    HomeScreen(),
    AssignmentsScreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            const CustomDrawerHeader(),
            const SizedBox(
              height: 10,
            ),
            DrawerItem(
              iconData: FontAwesomeIcons.user,
              iconSize: 20,
              iconColor: primaryColor,
              itemColor: bodyTextColor,
              itemName: 'My Profile',
              onTap: () {},
            ),
            DrawerItem(
              iconData: FontAwesomeIcons.signOut,
              iconSize: 20,
              iconColor: primaryColor,
              itemColor: bodyTextColor,
              itemName: 'Sign Out',
              onTap: () {
                AuthProvider.of(context).signOut(context);
              },
            ),
          ],
        ),
      ),
      backgroundColor: baseColor,
      extendBody: true,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 1),
        decoration:  BoxDecoration(
          gradient: LinearGradient(
            colors: const [Colors.transparent, primaryColor, Colors.transparent],
            stops: [0,0.5*(currentIndex-1),1]
          ),
        ),
        child: BottomNavigationBar(
          selectedItemColor: primaryColor,
          onTap: (val) {
            setState(() {
              currentIndex = val;
            });
          },
          unselectedItemColor: Colors.black87,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          currentIndex: currentIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.inbox), label: 'Inbox'),
            BottomNavigationBarItem(
                icon: Icon(Icons.people), label: 'Tutors'),
            BottomNavigationBarItem(
              icon: Icon(
                IconsaxOutline.home,
                size: 32,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.edit_document), label: 'Assignments '),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_2_rounded), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

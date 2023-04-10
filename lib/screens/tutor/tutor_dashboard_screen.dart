import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:tutor_app/constants/colors.dart';
import 'package:tutor_app/screens/tutor/assignments_screen.dart';
import 'package:tutor_app/screens/tutor/home_screen.dart';
import 'package:tutor_app/screens/tutor/inbox_screen.dart';
import 'package:tutor_app/screens/tutor/profile_screen.dart';
import 'package:tutor_app/screens/tutor/students_screen.dart';
import 'package:tutor_app/widgets/common/custom_appbar.dart';

class TutorDashboardScreen extends StatefulWidget {
  const TutorDashboardScreen({Key? key}) : super(key: key);

  @override
  _TutorDashboardScreenState createState() => _TutorDashboardScreenState();
}

class _TutorDashboardScreenState extends State<TutorDashboardScreen> {
  int currentIndex = 2;

  

  static const List<Widget> screens=[InboxScreen(),StudentsScreen(),HomeScreen(),AssignmentsScreen(),ProfileScreen()];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      backgroundColor: baseColor,
      extendBody: true,
      appBar: CustomAppBar(
        title: 'Dashboard',
        backgroundColor: Colors.transparent,
        canPop: false,
        centerTitle: true,
        leading: IconButton(onPressed: (){}, icon: const Icon(Icons.menu)),
      ),
      bottomNavigationBar: FloatingNavbar(
        itemBorderRadius: 16,
        elevation: 20,
        borderRadius: 16,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        selectedBackgroundColor: Colors.blue,
        onTap: (int val) {
          setState(() {
            currentIndex=val;
          });
        },
        currentIndex: currentIndex,
        items: [
          FloatingNavbarItem(icon: Icons.inbox, title: 'Inbox'),
          FloatingNavbarItem(icon: Icons.people, title: 'Students'),
          FloatingNavbarItem(icon: Icons.home,),
          FloatingNavbarItem(icon: Icons.edit_document, title: 'Assignments '),
          FloatingNavbarItem(icon: Icons.person_2_rounded, title: 'Profile'),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_app/constants/colors.dart';
import 'package:tutor_app/providers/auth_provider.dart';
import 'package:tutor_app/screens/student/assignment/assignments_review.dart';
import 'package:tutor_app/screens/student/tutors/find_tutor_screen.dart';
import 'package:tutor_app/widgets/session_list.dart';

import '../../widgets/common/custom_appbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const CustomAppBar(
            title: 'Dashboard',
            backgroundColor: Colors.transparent,
            canPop: false,
            centerTitle: true,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: AspectRatio(
                          aspectRatio: 17 / 12,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: RichText(
                                  text: TextSpan(
                                      text: 'Welcome back!',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black),
                                      children: [
                                        TextSpan(
                                            text: Provider.of<AuthProvider>(context).currentUser.name.split(' ').first,
                                            style: const TextStyle(
                                                color: primaryColor,
                                                fontSize: 18)),
                                      ]),
                                ),
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: AspectRatio(
                          aspectRatio: 17 / 12,
                          child: Material(
                            borderRadius: BorderRadius.circular(8),
                            elevation: 4,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder:(context) => const AssignmentsReview(),));
                              },
                              child: Row(
                                children: [
                                  const Expanded(
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Review',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            'Assignments',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Image.asset(
                                    'assets/performance.png',
                                  ))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: AspectRatio(
                    aspectRatio: 20 / 27,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(8),
                        elevation: 4,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder:(context) => const FindTutorScreen(),));
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Look for',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      'New Tutors',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                  child: Image.asset(
                                'assets/search.png',
                              ))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Scheduled Sessions',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SessionList(isStudent:true),
          const SizedBox(height: 16),
          // const Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 8),
          //   child: Align(
          //     alignment: Alignment.topLeft,
          //     child: Text(
          //       'Recent Submissions',
          //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

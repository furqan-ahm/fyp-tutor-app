import 'package:flutter/material.dart';
import 'package:tutor_app/constants/colors.dart';

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
                                  text: const TextSpan(
                                      text: 'Welcome back!',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black),
                                      children: [
                                        TextSpan(
                                            text: ' Anwar',
                                            style: TextStyle(
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
                            elevation: 8,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () {},
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Text(
                                            'Create a',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            'Quiz',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Image.asset('assets/Quiz.png'))
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
                        elevation: 8,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {},
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text(
                                'Schedule a',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              const Text(
                                'Tutoring Session',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              Image.asset('assets/OnlineMeeting.png')
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
          Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              color: bodyTextColor.withOpacity(0.07),
              child: RichText(
                text: const TextSpan(
                    text: 'Your scheduled sessions',
                    style: TextStyle(fontSize: 16, color: primaryColor),
                    children: [
                      TextSpan(
                          text:
                              ' will appear here once you schedule a meeting in advance.',
                          style: TextStyle(color: Colors.black)),
                    ]),
              )),
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

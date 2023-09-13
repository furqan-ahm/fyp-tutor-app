import 'package:flutter/material.dart';
import 'package:tutor_app/constants/colors.dart';
import 'package:tutor_app/screens/tutor/assignment/create_assignment_screen.dart';

import '../../../models/assignment_model.dart';
import '../../../widgets/common/custom_appbar.dart';
import '../../../widgets/common/custom_button.dart';

class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({Key? key}) : super(key: key);

  @override
  _AssignmentsScreenState createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  List<Assignment> assignments = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CustomAppBar(
          title: 'Assignments',
          backgroundColor: Colors.transparent,
          canPop: false,
          centerTitle: true,
        ),
        Expanded(
            child: assignments.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Column(children: [
                        Image.asset('assets/Student.png'),
                        Text(
                          "You haven't beem assigned any work yet.",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                  color: bodyTextColor.withOpacity(0.5)),
                          textAlign: TextAlign.center,
                        ),
                      ]),
                    ),
                  )
                : Column(
                    children: [],
                  ))
      ],
    );
  }
}

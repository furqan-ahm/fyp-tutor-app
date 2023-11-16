import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:tutor_app/constants/colors.dart';
import 'package:tutor_app/providers/auth_provider.dart';
import 'package:tutor_app/repository/firebase_firestore_repo.dart';
import 'package:tutor_app/screens/tutor/assignment/create_assignment_screen.dart';
import 'package:tutor_app/screens/tutor/assignment/view_submission_screen.dart';
import 'package:tutor_app/theme.dart';

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
    return Container(
      child: Column(
        children: [
          CustomAppBar(
            title: 'Assignments',
            backgroundColor: Colors.transparent,
            canPop: false,
            centerTitle: true,
            trailing: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateAssignmentScreen(),
                      ));
                },
                child: Container(
                  width: 35,
                  decoration: const BoxDecoration(
                      gradient:
                          LinearGradient(colors: [accentColor, primaryColor]),
                      shape: BoxShape.circle),
                  child: const Center(
                      child: Icon(
                    Icons.add,
                    size: 24,
                    color: Colors.white,
                  )),
                ),
              ),
            ),
          ),
          StreamBuilder<List<Assignment>>(
              stream: FirestoreRepository.getRelevantAssignments(
                  AuthProvider.of(context).currentUser.uid),
              builder: (context, snapshot) {
                assignments = snapshot.data?.where((element) => !element.closed).toList() ?? [];
                return Expanded(
                    child: assignments.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(28.0),
                              child: Column(children: [
                                Image.asset('assets/Student.png'),
                                Text(
                                  "You haven't assigned any work to your students yet.",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                          color:
                                              bodyTextColor.withOpacity(0.5)),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                CustomButton(
                                  buttonText: 'Create Assignment',
                                  onPressed: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const CreateAssignmentScreen(),
                                        ));
                                  },
                                )
                              ]),
                            ),
                          )
                        : ListView.builder(
                            itemCount: assignments.length,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Material(
                                borderRadius: BorderRadius.circular(11),
                                color: Colors.white,
                                elevation: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: primaryColor),
                                            child: const Icon(
                                              IconsaxOutline.user,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            assignments[index].student.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall!
                                                .copyWith(fontSize: 18),
                                          ),
                                          const Spacer(),
                                          IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                  IconsaxOutline.receipt_edit))
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            assignments[index].name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall!
                                                .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                          ),
                                          
                                          assignments[index].hasAttachment?const Icon(Icons.attach_file, size: 16,):const SizedBox.shrink()
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        assignments[index].details ??
                                            'No details',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall!
                                            .copyWith(
                                                color: Colors.black54,
                                                overflow: TextOverflow.ellipsis,
                                                fontSize: 16),
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      const SizedBox(height: 15),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Total Points: ${assignments[index].points ?? 00.toStringAsFixed(2)}',
                                                style: theme
                                                    .textTheme.headlineSmall
                                                    ?.copyWith(
                                                        color: Colors.black54,
                                                        fontSize: 14),
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                    text: "Deadline: ",
                                                    style: theme
                                                        .textTheme.headlineSmall
                                                        ?.copyWith(
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 14),
                                                    children: [
                                                      TextSpan(
                                                        text: assignments[index]
                                                            .timeString,
                                                      )
                                                    ]),
                                              ),
                                            ],
                                          ),
                                          // relevantSessions[index].isLive ||
                                          //         (!widget.isStudent &&
                                          //             relevantSessions[index]
                                          //                 .isActiveTime)
                                          GestureDetector(
                                            onTap: (){
                                              if(assignments[index].submitted)Navigator.push(context, MaterialPageRoute(builder:(context) => ViewSubmissionScreen(assignment: assignments[index]),));
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 10),
                                              decoration: BoxDecoration(
                                                color: assignments[index]
                                                        .submitted
                                                    ? Colors.green
                                                    : (assignments[index]
                                                            .deadline
                                                            .isAfter(
                                                                DateTime.now())
                                                        ? Colors.blue
                                                        : Colors.red),
                                                borderRadius: const BorderRadius.all(
                                                    Radius.circular(20)),
                                              ),  
                                              child: assignments[index].submitted
                                                  ? const Text(
                                                      'Submitted',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    )
                                                  : (assignments[index]
                                                          .deadline
                                                          .isAfter(DateTime.now())
                                                      ? const Text(
                                                          ' Due ',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        )
                                                      : const Text(
                                                          'Past Due',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        )),
                                            ),
                                          )
                                          //     : const SizedBox.shrink()
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ));
              })
        ],
      ),
    );
  }
}

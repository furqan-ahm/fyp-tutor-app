import 'package:date_time_format/date_time_format.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:tutor_app/constants/colors.dart';
import 'package:tutor_app/models/assignment_model.dart';
import 'package:tutor_app/repository/firebase_firestore_repo.dart';
import 'package:tutor_app/theme.dart';
import 'package:tutor_app/widgets/assignment/grade_dialog.dart';
import 'package:tutor_app/widgets/common/custom_button.dart';
import 'package:tutor_app/widgets/common/max_sized_container.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewSubmissionScreen extends StatefulWidget {
  const ViewSubmissionScreen({Key? key, required this.assignment, this.isTutor=true})
      : super(key: key);

  final Assignment assignment;
  final bool isTutor;
  @override
  _ViewSubmissionScreenState createState() => _ViewSubmissionScreenState();
}

class _ViewSubmissionScreenState extends State<ViewSubmissionScreen> {
  @override
  void initState() {
    super.initState();
    print(widget.assignment.submitID);
    FirestoreRepository.getSubmission(widget.assignment).then((value) {
      setState(() {
        submission = value;
        loading = false;
      });
    });
  }

  Submission? submission;

  bool loading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: MaxSizedContainer(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          safePadding: MediaQuery.of(context).padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Submission for:',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    widget.assignment.name,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Details: ',
                        style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Expanded(
                          child: Text(
                        widget.assignment.details ?? 'None',
                        softWrap: true,
                        style: theme.textTheme.headlineMedium
                            ?.copyWith(fontSize: 16),
                      ))
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Points: ',
                        style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Expanded(
                          child: Text(
                        widget.assignment.points?.toStringAsFixed(2) ?? 'None',
                        softWrap: true,
                        style: theme.textTheme.headlineMedium
                            ?.copyWith(fontSize: 16),
                      ))
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Deadline: ',
                        style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Expanded(
                          child: Text(
                        widget.assignment.time.format('h:i A, j M Y'),
                        softWrap: true,
                        style: theme.textTheme.headlineMedium
                            ?.copyWith(fontSize: 16),
                      ))
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    "Submission",
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  loading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Message: ',
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                ),
                                Expanded(
                                    child: Text(
                                  submission!.detail ?? '',
                                  softWrap: true,
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(fontSize: 16),
                                ))
                              ],
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Submitted at: ',
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                ),
                                Expanded(
                                    child: Text(
                                  submission!.submissionTime
                                      .format('h:i A, j M Y'),
                                  softWrap: true,
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(fontSize: 16),
                                ))
                              ],
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Attached: ',
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                ),
                                Expanded(
                                    child: Text(
                                  submission!.attached != null ? '' : 'None',
                                  softWrap: true,
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(fontSize: 16),
                                ))
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            submission!.attached != null
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(11),
                                      color: greyButtonColor,
                                      elevation: 2,
                                      child: InkWell(
                                        onTap: () {
                                          launchUrl(Uri.parse(
                                              submission!.attached!['url']));
                                        },
                                        borderRadius: BorderRadius.circular(11),
                                        child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      IconsaxOutline.document,
                                                      color: Colors.green,
                                                    ),
                                                    const SizedBox(
                                                      width: 4,
                                                    ),
                                                    Text(
                                                      submission!
                                                          .attached!['name'],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )),
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            const SizedBox(
                              height: 40,
                            ),
                            widget.isTutor?CustomButton(
                              buttonText: 'Approve and Grade',
                              fullWidth: true,
                              onPressed: () async {
                                if (widget.assignment.points != null) {
                                  await showDialog(
                                    context: context,
                                    builder: (context) => GradeDialog(
                                        assignment: widget.assignment),
                                  ).then((value) {
                                    if (value) Navigator.pop(context);
                                  });
                                } else {
                                  FirestoreRepository.closeAssignment(
                                          widget.assignment)
                                      .then((value) => Navigator.pop(context));
                                }
                              },
                            ):const SizedBox.shrink()
                          ],
                        ),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}

import 'dart:io';

import 'package:date_time_format/date_time_format.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:tutor_app/constants/colors.dart';
import 'package:tutor_app/models/assignment_model.dart';
import 'package:tutor_app/providers/assignment_provider.dart';
import 'package:tutor_app/providers/auth_provider.dart';
import 'package:tutor_app/repository/firebase_storage_repo.dart';
import 'package:tutor_app/theme.dart';
import 'package:tutor_app/utils/utils.dart';
import 'package:tutor_app/widgets/common/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';

class SubmissionScreen extends StatefulWidget {
  const SubmissionScreen({Key? key, required this.assignment})
      : super(key: key);

  final Assignment assignment;

  @override
  _SubmissionScreenState createState() => _SubmissionScreenState();
}

class _SubmissionScreenState extends State<SubmissionScreen> {
  TextEditingController detailCont = TextEditingController();

  File? convertedFile;
  PlatformFile? attachedFile;

  attachFile() async {
    var file = await Utils.pickFile();
    if (file == null) {
      return;
    }
    setState(() {
      attachedFile = file;
      convertedFile = File(file.path!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Assignment:',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        widget.assignment.name,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 24),
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
                            widget.assignment.points?.toStringAsFixed(2) ??
                                'None',
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
                        height: 4,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Attached: ',
                            style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Expanded(
                              child: Text(
                            widget.assignment.hasAttachment ? '' : 'None',
                            softWrap: true,
                            style: theme.textTheme.headlineMedium
                                ?.copyWith(fontSize: 16),
                          ))
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      widget.assignment.hasAttachment
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Material(
                                borderRadius: BorderRadius.circular(11),
                                color: greyButtonColor,
                                elevation: 2,
                                child: InkWell(
                                  onTap: () {
                                    launchUrl(Uri.parse(widget
                                        .assignment.attachedFiles!['url']));
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
                                                widget.assignment
                                                    .attachedFiles!['name'],
                                                overflow: TextOverflow.ellipsis,
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
                        height: 20,
                      ),
                      CustomButton(
                        onPressed: () async {
                          attachFile();
                        },
                        prefixWidget: const Icon(
                          Icons.attach_file,
                          size: 16,
                        ),
                        fullWidth: true,
                        buttonText: 'Attach Submission',
                      ),
                      const SizedBox(height: 10,),
                      attachedFile != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Material(
                          borderRadius: BorderRadius.circular(11),
                          color: greyButtonColor,
                          elevation: 2,
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
                                        attachedFile!.name,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            attachedFile = null;
                                            convertedFile = null;
                                          });
                                        },
                                        child: const Icon(Icons.close),
                                      )
                                    ],
                                  ),
                                ],
                              )),
                        ),
                      )
                    : const SizedBox.shrink(),
                      const SizedBox(
                        height: 30,
                      ),
                      TextField(
                        controller: detailCont,
                        textAlign: TextAlign.start,
                        maxLines: 5,
                        decoration: InputDecoration(
                          constraints: BoxConstraints(
                            maxWidth: double.infinity,
                            minHeight: MediaQuery.of(context).size.height * 0.2,
                          ),

                          // alignLabelWithHint: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          isDense: false,
                          fillColor: const Color(0xffEFEFEF),
                          filled: true,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(11),
                            ),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'Submission Details',
                          hintStyle:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: bodyTextColor.withOpacity(0.5),
                                  ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomButton(
                        buttonText: 'Submit It',
                        fullWidth: true,
                        onPressed: () async {
                          if (attachedFile == null || detailCont.text.isEmpty) {
                            Utils.showSnackbar(
                                'Please fill all required fields before proceeding',
                                context);
                            return false;
                          }
                          String? res;
                          if (convertedFile != null) {
                            res = await uploadFile(
                                AuthProvider.of(context).currentUser.uid,
                                convertedFile!,
                                DateTime.now().toIso8601String());
                          }
                          if (await AssignmentProvider.of(context)
                              .submitAssignment(
                                  widget.assignment.id,
                                  detailCont.text,
                                  {'name': attachedFile!.name, 'url': res},
                                  AuthProvider.of(context).currentUser)) {
                            Utils.showSnackbar('Submitted!', context);
                            Future.delayed(const Duration(seconds: 1), () {
                              Navigator.pop(context);
                            });
                          }

                          return true;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            )),
      )),
    );
  }
}

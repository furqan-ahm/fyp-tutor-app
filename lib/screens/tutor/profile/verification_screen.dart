import 'dart:io';

import 'package:ficonsax/ficonsax.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:tutor_app/constants/colors.dart';
import 'package:tutor_app/models/user_model.dart';
import 'package:tutor_app/providers/auth_provider.dart';
import 'package:tutor_app/repository/firebase_firestore_repo.dart';
import 'package:tutor_app/theme.dart';
import 'package:tutor_app/utils/utils.dart';
import 'package:tutor_app/widgets/common/custom_button.dart';
import 'package:tutor_app/widgets/common/max_sized_container.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({Key? key}) : super(key: key);

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  int get verificationStatus => user.verificationStatus;

  AppUser get user => AuthProvider.of(context).currentUser;

  File? convertedDegreeFile;
  PlatformFile? attachedDegreeFile;

  File? convertedNICFile;
  PlatformFile? attachedNICFile;

  attachNICFile() async {
    var file = await Utils.pickFile();
    if (file == null) {
      return;
    }
    setState(() {
      attachedNICFile = file;
      convertedNICFile = File(file.path!);
    });
  }

  attachDegreeFile() async {
    var file = await Utils.pickFile();
    if (file == null) {
      return;
    }
    setState(() {
      attachedDegreeFile = file;
      convertedDegreeFile = File(file.path!);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: verificationStatus == 0
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Profile',
                              style: theme.textTheme.headlineMedium
                                  ?.copyWith(fontSize: 18),
                            ),
                            Text('Verification',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 19)),
                            const SizedBox(
                              height: 40,
                            ),
                            Text('Attach NIC in PDF format',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.w600, fontSize: 17)),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomButton(
                              onPressed: () async {
                                attachNICFile();
                              },
                              prefixWidget: const Icon(
                                Icons.attach_file,
                                size: 16,
                              ),
                              fullWidth: true,
                              buttonText: 'Attach File',
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            attachedNICFile != null
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
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
                                                    attachedNICFile!.name,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const Spacer(),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        attachedNICFile = null;
                                                        convertedNICFile = null;
                                                      });
                                                    },
                                                    child:
                                                        const Icon(Icons.close),
                                                  )
                                                ],
                                              ),
                                            ],
                                          )),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            const SizedBox(
                              height: 40,
                            ),
                            Text('Attach Degree proof in PDF format',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.w600, fontSize: 17)),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomButton(
                              onPressed: () async {
                                attachDegreeFile();
                              },
                              prefixWidget: const Icon(
                                Icons.attach_file,
                                size: 16,
                              ),
                              fullWidth: true,
                              buttonText: 'Attach File',
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            attachedDegreeFile != null
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
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
                                                    attachedNICFile!.name,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const Spacer(),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        attachedDegreeFile = null;
                                                        convertedDegreeFile = null;
                                                      });
                                                    },
                                                    child:
                                                        const Icon(Icons.close),
                                                  )
                                                ],
                                              ),
                                            ],
                                          )),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            const SizedBox(
                              height: 40,
                            ),
                            
                          ],
                        )
                      : Text(verificationStatus == 1
                          ? 'Your documents are being verified! Your profile wll be verified soon'
                          : 'Your profile has been verified!'),
                ),
                const Spacer(),
                verificationStatus == 0
                    ? CustomButton(
                        buttonText: 'Submit for Verification',
                        fullWidth: true,
                        onPressed: () async {
                          if (attachedDegreeFile != null &&
                              attachedNICFile != null) {
                            FirestoreRepository.addOrUpdateUserData(
                                    uid: user.uid,
                                    key: 'verifiedStatus',
                                    value: 1)
                                .then((value) {
                              setState(() {
                                user.verificationStatus = 1;
                              });
                            });
                          } else
                            Utils.showSnackbar(
                                'Please submit both documents', context);
                        },
                      )
                    : const SizedBox.shrink(),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

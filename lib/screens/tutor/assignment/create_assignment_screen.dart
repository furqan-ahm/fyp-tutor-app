import 'dart:ffi';
import 'dart:io';

import 'package:ficonsax/ficonsax.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tutor_app/models/user_model.dart';
import 'package:tutor_app/providers/assignment_provider.dart';
import 'package:tutor_app/providers/auth_provider.dart';
import 'package:tutor_app/providers/tutorship_provider.dart';
import 'package:tutor_app/repository/firebase_storage_repo.dart';
import 'package:tutor_app/theme.dart';
import 'package:tutor_app/utils/utils.dart';
import 'package:tutor_app/widgets/assignment/pick_datetime_dialog.dart';
import 'package:tutor_app/widgets/common/custom_button.dart';
import 'package:tutor_app/widgets/common/custom_textfield.dart';
import 'package:tutor_app/widgets/common/max_sized_container.dart';

import '../../../constants/colors.dart';

class CreateAssignmentScreen extends StatefulWidget {
  const CreateAssignmentScreen({Key? key}) : super(key: key);

  @override
  _CreateAssignmentScreenState createState() => _CreateAssignmentScreenState();
}

class _CreateAssignmentScreenState extends State<CreateAssignmentScreen> {
  AppUser? selectedStudent;

  DateTime? deadlineDate;

  File? convertedFile;
  PlatformFile? attachedFile;

  TextEditingController titleCont = TextEditingController();
  TextEditingController detailCont = TextEditingController();
  TextEditingController pointsCont = TextEditingController();

  TextEditingController deadline = TextEditingController();

  List<AppUser> students = [];

  @override
  void initState() {
    super.initState();
    Provider.of<TutorshipProvider>(context, listen: false)
        .getStudents(context)
        .then((value) {
      setState(() {
        students = value;
      });
    });
  }

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
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                        'Create Assignment',
                        style: theme.textTheme.headlineMedium
                            ?.copyWith(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Form(
                    child: Column(
                      children: [
                        CustomFormField(
                          labelText: 'Title',
                          primaryColor: primaryColor,
                          controller: titleCont,
                          textColor: Colors.black,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomFormField(
                          labelText: 'Points (Optional)',
                          primaryColor: primaryColor,
                          controller: pointsCont,
                          textColor: Colors.black,
                          textInputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Material(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          elevation: 1,
                          color: greyButtonColor,
                          shadowColor: bodyTextColor.withOpacity(0.7),
                          child: SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 12, right: 12),
                              child: DropdownButton<AppUser>(
                                isExpanded: true,
                                hint: Text('Student',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: bodyTextColor.withOpacity(0.5),
                                        )),
                                dropdownColor: greyButtonColor,
                                focusColor: Colors.transparent,
                                value: selectedStudent,
                                borderRadius: BorderRadius.circular(8),
                                underline: const SizedBox.shrink(),
                                items: students
                                    .map((e) => DropdownMenuItem<AppUser>(
                                        value: e, child: Text(e.name)))
                                    .toList(),
                                onChanged: (val) {
                                  setState(() {
                                    selectedStudent = val;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomFormField(
                          labelText: 'Date of Submission',
                          enabled: false,
                          controller: deadline,
                          suffixWidget: GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      const PickDatetimeDialog(),
                                ).then((value) {
                                  if (value is DateTime) {
                                    setState(() {
                                      deadlineDate = value;
                                      deadline.text =
                                          '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}, ${value.day}-${value.month}-${value.year}';
                                    });
                                  }
                                });
                              },
                              child: const Icon(IconsaxOutline.calendar)),
                        ),
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
                          buttonText: 'Attach File',
                        ),
                      ],
                    ),
                  ),
                ),
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
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: TextField(
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
                      hintText: 'Additional Instructions(Optional)',
                      hintStyle:
                          Theme.of(context).textTheme.bodyLarge!.copyWith(
                                color: bodyTextColor.withOpacity(0.5),
                              ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 10),
                  child: CustomButton(
                    buttonText: 'Assign It',
                    fullWidth: true,
                    onPressed: () async {
                      if (deadlineDate == null ||
                          titleCont.text.isEmpty ||
                          selectedStudent == null) {
                        Utils.showSnackbar(
                            'Please fill all required fields before proceeding',
                            context);
                      }
                      String? res;
                      if (convertedFile != null) {
                        res = await uploadFile(
                            AuthProvider.of(context).currentUser.uid,
                            convertedFile!,
                            DateTime.now().toIso8601String());
                      }
                      if (await AssignmentProvider.of(context).createAssignment(
                          titleCont.text,
                          AuthProvider.of(context).currentUser,
                          selectedStudent!,
                          deadlineDate!,
                          attached: attachedFile==null?null:{'name': attachedFile!.name, 'url': res},
                          details: detailCont.text,
                          points: pointsCont.text.isEmpty
                              ? null
                              : double.parse(pointsCont.text))) {
                        Utils.showSnackbar(
                            'Assignment created successfully', context);
                        Future.delayed(Duration(seconds: 2), () {
                          Navigator.pop(context);
                        });
                        return true;
                      }
                    },
                  ),
                ),
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

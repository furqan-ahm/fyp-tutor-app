import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:tutor_app/providers/auth_provider.dart';
import 'package:tutor_app/providers/session_provider.dart';
import 'package:tutor_app/providers/tutorship_provider.dart';
import 'package:tutor_app/screens/tutor/session_screen.dart';
import 'package:tutor_app/theme.dart';
import 'package:tutor_app/utils/utils.dart';
import 'package:tutor_app/utils/validation_utils.dart';
import 'package:tutor_app/widgets/assignment/pick_datetime_dialog.dart';
import 'package:tutor_app/widgets/common/custom_appbar.dart';
import 'package:tutor_app/widgets/common/custom_button.dart';
import 'package:tutor_app/widgets/common/custom_textfield.dart';
import 'package:tutor_app/widgets/common/max_sized_container.dart';

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../../constants/colors.dart';
import '../../models/session_model.dart';
import '../../models/user_model.dart';

class CreateSessionScreen extends StatefulWidget {
  const CreateSessionScreen({Key? key}) : super(key: key);

  @override
  _CreateSessionScreenState createState() => _CreateSessionScreenState();
}

class _CreateSessionScreenState extends State<CreateSessionScreen> {
  AppUser? selectedStudent;

  List<AppUser> students = [];

  bool scheduleLater = false;

  DateTime? sessionDate;
  bool loadingMedia = false;

  PlatformFile? attachedFile;
  //List<Map> attachedMedia;
  File? convertedFile;

  TextEditingController titleCont = TextEditingController();
  
  TextEditingController durationCont = TextEditingController(text: '60');
  TextEditingController sessionTime = TextEditingController(text: '');


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
    if (file.extension == 'pdf') {
      setState(() {
        attachedFile = file;
        convertedFile = File(file.path!);
      });
      return;
    }

    setState(() {
      attachedFile = file;
      loadingMedia = true;
    });
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.pspdfkit.com/build'),
      );

      final instructions = {
        "parts": [
          {
            "file": "document",
          },
        ],
      };

      request.headers['Authorization'] =
          'Bearer pdf_live_SWM8owlRqAjaXQTI29Golhwj3a5FLKojPwJUAGq0Xof';
      request.fields['instructions'] = json.encode(instructions);
      request.files.add(
        await http.MultipartFile.fromPath(
          'document',
          file.path!,
          contentType: MediaType('application',
              'vnd.openxmlformats-officedocument.presentationml.presentation'),
        ),
      );

      final response = await request.send();

      if (response.statusCode == 200) {
        final appDocumentsDir = await getApplicationDocumentsDirectory();

        final outputFile = File('${appDocumentsDir.path}/result.pdf');
        await response.stream.pipe(outputFile.openWrite());
        print('File downloaded successfully.');
        setState(() {
          convertedFile = outputFile;
          loadingMedia = false;
        });
      } else {
        print('Failed to fetch PDF: ${response.statusCode}');
        print(await response.stream.bytesToString());
        setState(() {
          attachedFile = null;
          loadingMedia = false;
        });
      }
    } catch (e) {
      setState(() {
        attachedFile = null;
        loadingMedia = false;
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: MaxSizedContainer(
            safePadding: MediaQuery.of(context).padding,
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
                        'Schedule/Create an',
                        style: theme.textTheme.headlineMedium
                            ?.copyWith(fontSize: 18),
                      ),
                      Text('Session',
                          style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 19)),
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
                          labelText: 'Meeting Duration (in minutes)',
                          controller: durationCont,
                          textInputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'\d+')),],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        scheduleLater
                            ? CustomFormField(
                                labelText: 'Date of Session',
                                controller: sessionTime,
                                enabled: false,
                                suffixWidget: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            const PickDatetimeDialog(),
                                      ).then((value){
                                        if(value is DateTime){
                                          setState(() {
                                            sessionDate=value;
                                            sessionTime.text='${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}, ${value.day}-${value.month}-${value.year}';
                                          });
                                        }
                                      });
                                    },
                                    child: const Icon(IconsaxOutline.calendar)),
                              )
                            : const SizedBox.shrink(),
                        Row(
                          children: [
                            Checkbox(
                              value: scheduleLater,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4))),
                              onChanged: (val) {
                                setState(() {
                                  scheduleLater = val ?? false;
                                });
                              },
                            ),
                            const Text(
                              'Schedule for later',
                            )
                          ],
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
                          buttonText: 'Attach PPT/PDF',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
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
                                      loadingMedia
                                          ? const SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ))
                                          : GestureDetector(
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
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 10),
                  child: CustomButton(
                    buttonText:
                        scheduleLater ? 'Confirm Schedule' : 'Start Session',
                    fullWidth: true,
                    onPressed: () async {

                      if(titleCont.text.isEmpty||durationCont.text.isEmpty||selectedStudent==null){
                        Utils.showSnackbar('Please fill all fields before proceeding', context);
                        return false;
                      }

                      if(sessionDate!=null&&sessionDate!.isBefore(DateTime.now())){
                        Utils.showSnackbar('You can not schedule a meeting in the past', context);
                        return false;
                      }

                      if (!loadingMedia) {
                          var result=await Provider.of<SessionProvider>(context,
                                listen: false)
                            .createSession(
                                titleCont.text,
                                selectedStudent!,
                                attachedFile != null
                                    ? {attachedFile!.name: convertedFile}
                                    : {},
                                AuthProvider.of(context).currentUser,
                                sessionDate??DateTime.now(), int.parse(durationCont.text));
                          if(!scheduleLater && result is Session){
                            Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => SessionScreen(session: result),));
                            return true;
                          }
                        Navigator.pop(context);
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

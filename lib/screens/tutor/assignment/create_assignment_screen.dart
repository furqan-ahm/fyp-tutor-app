import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tutor_app/theme.dart';
import 'package:tutor_app/utils/validation_utils.dart';
import 'package:tutor_app/widgets/assignment/pick_datetime_dialog.dart';
import 'package:tutor_app/widgets/common/custom_appbar.dart';
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
  String? selectedStudent;

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
                        'Create an',
                        style: theme.textTheme.headlineMedium
                            ?.copyWith(fontSize: 18),
                      ),
                      Text('assignment',
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
                              child: DropdownButton<String>(
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
                                items: ['Hamza', 'Rizwan']
                                    .map((e) => DropdownMenuItem<String>(
                                        value: e, child: Text(e)))
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
                          suffixWidget: GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      const PickDatetimeDialog(),
                                );
                              },
                              child: const Icon(IconsaxOutline.calendar)),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomButton(
                          onPressed: () async {},
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
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:18.0),
                  child: TextField(
                    textAlign: TextAlign.start,
                    maxLines: 5,
                    decoration: InputDecoration(
                      constraints: BoxConstraints(
                        maxWidth: double.infinity,
                        minHeight: MediaQuery.of(context).size.height * 0.2,
                      ),
                      suffixIcon: Transform.translate(
                        offset: Offset(
                          3,
                          -MediaQuery.of(context).size.height * 0.05,
                        ),
                        child: Icon(
                          IconsaxOutline.microphone_2,
                          color: bodyTextColor.withOpacity(0.5),
                        ),
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
                      hintText: 'Additional Instructions',
                      hintStyle:
                          Theme.of(context).textTheme.bodyLarge!.copyWith(
                                color: bodyTextColor.withOpacity(0.5),
                              ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                  child: CustomButton(
                    buttonText: 'Assign It',
                    fullWidth: true,
                    onPressed: () async {},
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

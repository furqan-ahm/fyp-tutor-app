import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chip_tags/flutter_chip_tags.dart';
import 'package:tutor_app/constants/degrees.dart';
import 'package:tutor_app/models/user.dart';

import '../../constants/colors.dart';
import '../../widgets/common/custom_textfield.dart';

class EducationLevelScreen extends StatefulWidget {
  final UserRole selectedRole;

  const EducationLevelScreen({Key? key, required this.selectedRole})
      : super(key: key);

  @override
  _EducationLevelScreenState createState() => _EducationLevelScreenState();
}

class _EducationLevelScreenState extends State<EducationLevelScreen> {
  List<String> get educationLevels =>
      ["Primary", "Secondary", "HSC", "SSC", "O/A-Levels", "Bachelors"];

  String? selectedEducation;
  TextEditingController instituteCont = TextEditingController();
  TextEditingController subjectCont = TextEditingController();

  List<String> subjects = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(onPressed: (){}, label: const Text('Continue')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              IconButton(
                // to remove default padding of the icon button
                padding: EdgeInsets.zero,
                // You have to pass the empty constrains because, by default, the IconButton widget assumes a minimum size of 48px.
                constraints: const BoxConstraints(),
                //
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: bodyTextColor,
                  size: 20,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Hero(
                    tag: widget.selectedRole.name,
                    child: Image.asset(
                      'assets/Profile.png',
                      height: 150,
                    ),
                  ),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Setup'),
                        Text(
                          'Education',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontSize: 28),
                        ),
                        Text(
                          'Details',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontSize: 28),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 24),
              widget.selectedRole == UserRole.Teacher
                  ? Material(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      elevation: 1,
                      shadowColor: bodyTextColor.withOpacity(0.7),
                      child: DropdownSearch<String>(
                        selectedItem: selectedEducation,
                        items: degrees,
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          containerBuilder: (context, popupWidget) => Container(
                            color: greyButtonColor,
                            child: popupWidget,
                          ),
                        ),
                        dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                          filled: true,
                          fillColor: greyButtonColor,
                          contentPadding:
                              const EdgeInsets.only(left: 12, right: 12),
                          labelStyle:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: bodyTextColor.withOpacity(0.5),
                                  ),
                          floatingLabelStyle:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: bodyTextColor.withOpacity(0.5),
                                  ),
                          label: const Text(
                            "Degree Attained",
                          ),
                          errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: primaryColor,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: bodyTextColor.withOpacity(0.5),
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                        )),
                        onChanged: (val) {},
                      ),
                    )
                  : Material(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      elevation: 1,
                      color: greyButtonColor,
                      shadowColor: bodyTextColor.withOpacity(0.7),
                      child: SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            hint: Text('Education Level',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: bodyTextColor.withOpacity(0.5),
                                    )),
                            dropdownColor: greyButtonColor,
                            focusColor: Colors.transparent,
                            value: selectedEducation,
                            borderRadius: BorderRadius.circular(8),
                            underline: const SizedBox.shrink(),
                            items: educationLevels
                                .map((e) => DropdownMenuItem<String>(
                                    value: e, child: Text(e)))
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                selectedEducation = val;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
              const SizedBox(
                height: 24,
              ),
              CustomFormField(
                controller: instituteCont,
                textFieldBgColor: greyButtonColor,
                labelText: 'Institute Name',
                isPassword: false,
                validatorFunction: (v) {
                  return null;
                },
                primaryColor: primaryColor,
                textColor: bodyTextColor,
                isLabelCenter: false,
              ),
              const SizedBox(
                height: 24,
              ),
              Text(
                'Subjects',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontSize: 28),
              ),
              const Text('of interest'),
              const SizedBox(
                height: 24,
              ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: CustomFormField(
              //         controller: subjectCont,
              //         textFieldBgColor: greyButtonColor,
              //         labelText: 'Subject Name',
              //         isPassword: false,
              //         validatorFunction: (v) {
              //           return null;
              //         },
              //         primaryColor: primaryColor,
              //         textColor: bodyTextColor,
              //         isLabelCenter: false,
              //       ),
              //     ),
              //     const SizedBox(
              //       width: 20,
              //     ),
              //     FloatingActionButton.extended(
              //       onPressed: () {

              //       },
              //       label: const Text('Add'),
              //       elevation: 2,
              //     )
              //   ],
              // ),
              // const SizedBox(
              //   height: 18,
              // ),
              ChipTags(
                list: subjects,
                createTagOnSubmit: true,
                chipColor: primaryColor,
                iconColor: Colors.white,
                textColor: Colors.white,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: greyButtonColor,
                  hintText: 'Add Subjects',
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: primaryColor,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: bodyTextColor.withOpacity(0.5),
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

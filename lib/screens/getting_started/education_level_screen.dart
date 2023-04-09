import 'package:flutter/material.dart';
import 'package:tutor_app/models/user.dart';

import '../../constants/colors.dart';

class EducationLevelScreen extends StatefulWidget {
  final UserRole selectedRole;

  const EducationLevelScreen({Key? key, required this.selectedRole})
      : super(key: key);

  @override
  _EducationLevelScreenState createState() => _EducationLevelScreenState();
}

class _EducationLevelScreenState extends State<EducationLevelScreen> {
  List<String> get educationLevels => widget.selectedRole == UserRole.Teacher
      ? ["Bachelors", "Masters", "Ph. D."]
      : ["Primary", "Secondary", "HSC", "SSC", "O/A-Levels", "Bachelors"];

  String? selectedEducation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Profile'),
                      Text(
                        'Setup',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 24),
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
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: DropdownButton<String>(
                      hint: Text('Education Attained',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: bodyTextColor.withOpacity(0.5),
                              )),
                      selectedItemBuilder: (context) =>
                          [Text(selectedEducation ?? '')],
                      dropdownColor: greyButtonColor,
                      value: selectedEducation,
                      borderRadius: BorderRadius.circular(8),
                      underline: const SizedBox(),
                      items: educationLevels
                          .map((e) =>
                              DropdownMenuItem<String>(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) {},
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

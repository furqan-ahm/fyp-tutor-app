import 'dart:io';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../providers/auth_provider.dart';
import '../../theme.dart';
import '../../utils/utils.dart';
import '../../utils/validation_utils.dart';
import '../../widgets/common/custom_appbar.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_textfield.dart';
import '../../widgets/common/max_sized_container.dart';
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController nickNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  DateTime? dob;
  String? imgPath;

  dynamic get dobString => '${dob?.day}/${dob?.month}/${dob?.year}';

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    final user = Provider.of<AuthProvider>(context, listen: false).currentUser;

    nameController.text = user.name;
    nickNameController.text = user.nickname;
    phoneController.text = user.contactNum;
    emailController.text = user.email;
    dobController.text = user.dobString;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                child: MaxSizedContainer(
      safePadding: MediaQuery.of(context).padding,
      padding: const EdgeInsets.all(20.0),
      child: Consumer<AuthProvider>(builder: (context, auth, _) {
        return Form(
          key: _formKey,
          child: Column(
            children: [
              const CustomAppBar(
                title: 'Profile',
                backgroundColor: Colors.transparent,
                canPop: true,
                centerTitle: true,
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: primaryColor),
                child: GestureDetector(
                  onTap: () {
                    Utils.showImagePickerSheet(context)
                        .then((value) => setState(
                              () => imgPath = value,
                            ));
                  },
                  child: CircleAvatar(
                      backgroundColor: primaryColor,
                      radius: 65,
                      backgroundImage: imgPath == null
                          ? NetworkImage(Provider.of<AuthProvider>(context)
                              .currentUser
                              .getProfilePictureURL)
                          : Image.file(File(imgPath!)).image),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              CustomFormField(
                  labelText: 'Full Name',
                  controller: nameController,
                  isPassword: false,
                  validatorFunction: ValidationUtils.validateName,
                  primaryColor: primaryColor,
                  textColor: bodyTextColor,
                  
                  isLabelCenter: false),
              const SizedBox(
                height: 15,
              ),
              CustomFormField(
                  labelText: 'Date of Birth',
                  controller: dobController,
                  enabled: false,
                  isPassword: false,
                  suffixWidget: GestureDetector(
                      onTap: () {
                        showCalendarDatePicker2Dialog(
                                context: context,
                                config:
                                    CalendarDatePicker2WithActionButtonsConfig(),
                                dialogSize: const Size(300, 400))
                            .then((value) {
                          if (value != null) {
                            dob = value.first;
                            if (dob != null)
                              dobController.text =
                                  '${dob!.day}/${dob!.month}/${dob!.year}';
                          }
                        });
                      },
                      child: const Icon(
                        IconsaxOutline.calendar,
                      )),
                  validatorFunction: (val) => null,
                  primaryColor: primaryColor,
                  textColor: bodyTextColor,
                  
                  isLabelCenter: false),
              const SizedBox(
                height: 15,
              ),
              CustomFormField(
                  labelText: 'Email',
                  controller: emailController,
                  enabled: false,
                  isPassword: false,
                  suffixWidget: const Icon(
                    Icons.mail,
                  ),
                  validatorFunction: (val) => null,
                  primaryColor: primaryColor,
                  textColor: bodyTextColor,
                  
                  isLabelCenter: false),
              const SizedBox(
                height: 15,
              ),
              CustomFormField(
                  labelText: 'Phone Number',
                  controller: phoneController,
                  isPassword: false,
                  prefixWidget: const Text('+92 '),
                  
                  validatorFunction: ValidationUtils.validateMobile,
                  primaryColor: primaryColor,
                  textColor: bodyTextColor,
                  
                  isLabelCenter: false),
              const SizedBox(
                height: 15,
              ),
              const Spacer(),
              CustomButton(
                fullWidth: true,
                buttonText: 'Update Profile',
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await auth.updateUserProfile(
                        auth.currentUser.copyWith(
                            name: nameController.text,
                            nickname: nickNameController.text,
                            phone: phoneController.text,
                            dob: dob),
                        imgPath: imgPath);
                  }
                },
              )
            ],
          ),
        );
      }),
    ))));
  }
}

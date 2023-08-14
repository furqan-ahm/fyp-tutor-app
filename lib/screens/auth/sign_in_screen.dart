import 'package:flutter/material.dart';
import 'package:tutor_app/screens/auth/select_role_screen.dart';
import 'package:tutor_app/screens/tutor/tutor_dashboard_screen.dart';

import '../../constants/colors.dart';
import '../../utils/loading_button.dart';
import '../../utils/validation_utils.dart';
import '../../widgets/common/custom_textfield.dart';
import '../../widgets/common/max_sized_container.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailCont = TextEditingController();
  TextEditingController passCont = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, //to make the textFormFields in view
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: MaxSizedContainer(
            safePadding: MediaQuery.of(context).padding,
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  const SizedBox(height: 24),
                  Text(
                    'Sign In',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 24),
                  CustomFormField(
                    controller: emailCont,
                    textFieldBgColor: greyButtonColor,
                    labelText: 'Email',
                    isPassword: false,
                    validatorFunction: (v) {
                      return ValidationUtils.validateEmail(v);
                    },
                    primaryColor: primaryColor,
                    textColor: bodyTextColor,
                    isLabelCenter: false,
                  ),
                  const SizedBox(height: 24),
                  CustomFormField(
                    controller: passCont,
                    textFieldBgColor: greyButtonColor,
                    labelText: 'Password',
                    isPassword: true,
                    validatorFunction: (v) {
                      return ValidationUtils.validatePassword(v);
                    },
                    primaryColor: primaryColor,
                    textColor: bodyTextColor,
                    isLabelCenter: false,
                  ),
                  const SizedBox(height: 24),
                  LoadingButton(
                    isLoading: false,
                    fullWidth: true,
                    buttonText: 'Sign In',
                    buttonBgColor: primaryColor,
                    buttonFontColor: Colors.white,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>TutorDashboardScreen()));
                      if (formKey.currentState!.validate()) {}
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: bodyTextColor.withOpacity(0.5),
                            ),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_)=>const SelectRoleScreen()));
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(color: primaryColor),
                          ))
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Spacer(),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

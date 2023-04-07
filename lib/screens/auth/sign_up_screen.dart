import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/colors.dart';
import '../../models/user.dart';
import '../../utils/loading_button.dart';
import '../../utils/validation_utils.dart';
import '../../widgets/auth/custom_textfield.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key, required this.selectedRole}) : super(key: key);

  final UserRole selectedRole;

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {


  TextEditingController emailCont = TextEditingController();
  TextEditingController passCont = TextEditingController();
  TextEditingController numCont = TextEditingController();
  TextEditingController nameCont = TextEditingController();


  final _formKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
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
                        'assets/${widget.selectedRole.name}.png',
                        height: 150,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(widget.selectedRole.name),
                        Text(
                          'Sign Up',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 24),
                CustomFormField(
                  controller: nameCont,
                  textFieldBgColor: greyButtonColor,
                  labelText: 'Name',
                  isPassword: false,
                  validatorFunction: (v) {
                    return ValidationUtils.validateName(v);
                  },
                  primaryColor: primaryColor,
                  textColor: bodyTextColor,
                  isLabelCenter: false,
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
                  // validatorFunction: (v) {
                  //   return null;
                  // },
                  validatorFunction: (v) {
                    return ValidationUtils.validatePassword(v);
                  },
                  primaryColor: primaryColor,
                  textColor: bodyTextColor,
                  isLabelCenter: false,
                ),
                const SizedBox(height: 24),
                CustomFormField(
                  textFieldBgColor: greyButtonColor,
                  labelText: 'Confirm Password',
                  isPassword: true,
                  validatorFunction: (v) {
                    return ValidationUtils.validateConfirmPassword(
                        passCont.text, v);
                  },
                  primaryColor: primaryColor,
                  textColor: bodyTextColor,
                  isLabelCenter: false,
                ),
                const SizedBox(height: 24),
                CustomFormField(
                  maxLength: 10,
                  textInputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    FilteringTextInputFormatter.deny(RegExp('^0+'))
                  ],
                  prefixWidget: Text(
                    '+92',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: primaryColor,
                        ),
                  ),
                  controller: numCont,
                  textFieldBgColor: greyButtonColor,
                  labelText: 'Phone number',
                  isPassword: false,
                  validatorFunction: (v) {
                    return ValidationUtils.validateMobile(v);
                  },
                  primaryColor: primaryColor,
                  textColor: bodyTextColor,
                  isLabelCenter: false,
                  
                ),
                const SizedBox(height: 24),
                LoadingButton(
                  isLoading: false,
                  fullWidth: true,
                  buttonText: 'Sign Up',
                  buttonBgColor: primaryColor,
                  buttonFontColor: Colors.white,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

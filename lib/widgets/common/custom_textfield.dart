import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tutor_app/utils/validation_utils.dart';

import '../../constants/colors.dart' as colors;
import '../../utils/mixins_classes.dart';

@immutable
class CustomFormField extends StatefulWidget {
  // const CustomFormField({Key? key}) : super(key: key);
  final String labelText;
  bool isPassword;
  final String? Function(String?)? validatorFunction;
  final TextEditingController? controller;
  final Color primaryColor;
  final int? minLines;
  final Color textColor;
  final Color textFieldBgColor;
  final bool isLabelCenter;
  final bool? enabled;
  Widget? suffixWidget;
  Widget? prefixWidget;
  int? maxLength;
  List<TextInputFormatter>? textInputFormatters;
  CustomFormField({
    this.textInputFormatters,
    this.maxLength,
    super.key,
    required this.labelText,
    this.isPassword = false,
    this.controller,
    this.minLines,
    this.suffixWidget,
    this.prefixWidget,
    this.enabled,
    this.validatorFunction = ValidationUtils.validateTextFormFieldForEmptyInput,
    this.primaryColor=colors.primaryColor,
    this.textColor = Colors.black,
    this.textFieldBgColor = colors.greyButtonColor,
    this.isLabelCenter = false,
  });

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  @override
  Widget build(BuildContext context) {
    return Material(
      //the extra border that comes out when there is a error in textfields is due to this material widget.
      //cuz the textfeild's border radius is also the same
      borderRadius: const BorderRadius.all(
        Radius.circular(8),
      ),
      elevation: 1,
      shadowColor: colors.bodyTextColor.withOpacity(0.7),
      child: TextFormField(
        minLines: widget.minLines,
        controller: widget.controller,
        obscureText: widget.isPassword,
        enableInteractiveSelection: (widget.enabled ?? true),
        focusNode: (widget.enabled ?? true) ? null : AlwaysDisabledFocusNode(),
        validator: widget.validatorFunction,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: widget.textColor,
            ),
        cursorColor: widget.primaryColor.withOpacity(0.5),
        maxLength: widget.maxLength,
        inputFormatters: widget.textInputFormatters,
        decoration: InputDecoration(
          counterText: '',
          prefix: widget.prefixWidget,
          //bg color of the textField
          filled: true,

          fillColor: widget.textFieldBgColor,

          suffixIcon: widget.labelText.contains('Password')
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.isPassword = !widget.isPassword;
                    });
                  },
                  child: SizedBox(
                    height: 24,
                    width: 24,
                    child: Icon(
                      widget.isPassword
                          ? FontAwesomeIcons.eye
                          : FontAwesomeIcons.eyeSlash,
                      color: widget.textColor.withOpacity(0.5),
                      size: 16,
                    ),
                  ),
                )
              : widget.suffixWidget,
          contentPadding: const EdgeInsets.only(left: 12, right: 12),
          labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: widget.textColor.withOpacity(0.5),
              ),

          floatingLabelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: widget.textColor.withOpacity(0.5),
              ),
          label: widget.isLabelCenter
              ? Center(
                  child: Text(
                    widget.labelText,
                  ),
                )
              : Text(
                  widget.labelText,
                ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: widget.primaryColor,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: widget.textColor.withOpacity(0.5),
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
    );
  }
}

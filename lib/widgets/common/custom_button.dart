import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class CustomButton extends StatefulWidget {
   const CustomButton(
      {Key? key,
      this.onPressed,
      this.fullWidth = false,
      this.prefixWidget,
      this.buttonText,
      this.elevation=2,
      this.height,
      this.backgroundColor,
      this.foregroundColor})
      : super(key: key);

  final Future Function()? onPressed;
  final String? buttonText;
  final Color? backgroundColor;
  final bool fullWidth;
  final double elevation;
  final double? height;
  final Widget? prefixWidget;
  final Color? foregroundColor;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: widget.onPressed == null || loading
            ? null
            : () async {
                setState(() {
                  loading = true;
                });
                await widget.onPressed!();
                setState(() {
                  loading = false;
                });
              },
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(widget.elevation),
          backgroundColor:
              MaterialStateProperty.all(widget.backgroundColor ?? primaryColor),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          minimumSize: widget.fullWidth
              ? MaterialStateProperty.all(
                   Size(double.infinity, widget.height??45),
                )
              : MaterialStateProperty.all( Size(0, widget.height??45)),
          maximumSize: widget.fullWidth
              ? MaterialStateProperty.all(
                   Size(double.infinity, widget.height??45),
                )
              : MaterialStateProperty.all( Size(double.maxFinite, widget.height??45)),
          //now the button color will be same even if it is not focused.
          overlayColor: MaterialStateProperty.resolveWith(
            (states) {
              if (states.contains(MaterialState.pressed)) {
                return accentColor.withOpacity(0.2);
              }

              return primaryColor; //default color
            },
          ),
        ),
        child: Padding(
          // padding:  EdgeInsets.all(16.0),
          padding:  const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
          child: loading
              ?  const SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
              )
              : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: widget.fullWidth?MainAxisSize.max:MainAxisSize.min,
                children: [
                  widget.prefixWidget?? const SizedBox.shrink(),
                  Text(
                      widget.buttonText ?? 'Press',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: widget.foregroundColor??Colors.white,
                        ),
                    ),
                ],
              ),
        ));
  }
}

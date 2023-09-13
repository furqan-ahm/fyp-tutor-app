import 'package:flutter/material.dart';

import '../constants/colors.dart';

class LoadingButton extends StatefulWidget {
  final String buttonText;
  final Color buttonBgColor;
  final Color buttonFontColor;
  // final Future Function() futurePressed;
  final VoidCallback onPressed;
  final bool fullWidth;
  final bool isLoading;
  const LoadingButton({
    Key? key,
    required this.buttonText,
    this.buttonBgColor = primaryColor,
    this.buttonFontColor = Colors.white,
    required this.onPressed,
    this.fullWidth = true,
    required this.isLoading,
  }) : super(key: key);

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  bool loading = false;

  // futurePressed() async {
  //   if (loading) return;
  //   setState(() {
  //     loading = true;
  //   });
  //   await widget.futurePressed();
  //   setState(() {
  //     loading = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(3),
        backgroundColor: MaterialStateProperty.all(
          widget.buttonBgColor,
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        minimumSize: widget.fullWidth
            ? MaterialStateProperty.all(
                const Size(double.infinity, 45),
              )
            : MaterialStateProperty.all(
                const Size(double.minPositive, 45),
              ),
        //now the button color will be same even if it is not focused.
        overlayColor: MaterialStateProperty.resolveWith(
          (states) {
            if (states.contains(MaterialState.pressed)) {
              return widget.buttonFontColor.withOpacity(0.2);
            }

            return widget.buttonBgColor; //default color
          },
        ),
      ),
      child: widget.isLoading
          ? Padding(
              padding: const EdgeInsets.all(4.0),
              child: Transform.scale(
                  scale: 0.6,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                  )),
            )
          : Padding(
              // padding: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
              child: Text(
                widget.buttonText,
                // style: TextStyle(
                //   fontSize: 16.0,
                //   color: buttonFontColor,
                // ),
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: widget.buttonFontColor,
                    ),
              ),
            ),
    );
  }
}

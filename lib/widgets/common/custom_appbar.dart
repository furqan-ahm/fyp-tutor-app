import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class CustomAppBar extends StatelessWidget {
  final Size preferredSize;
  const CustomAppBar({
    Key? key,
    this.isElevated = false,
    required this.title,
    this.centerTitle=false,
    this.foregroundColor = bodyTextColor,
    this.backgroundColor = Colors.white,
    this.trailing,
    this.leading,
    this.bottom,
    this.canPop = true,
    this.fontWeight = FontWeight.w600,
  })  : preferredSize = bottom == null
            ? const Size.fromHeight(56)
            : const Size.fromHeight(96),
        super(key: key);
        
      //: preferredSize = bottom==null?const Size.fromHeight(56):Size.fromHeight(56+bottom.preferredSize.height),super(key: key);
      //This implementation removes makes widget non const but is more dynamic
      //

  final bool centerTitle;
  final String title;
  final bool isElevated;
  final Widget? trailing;
  final Widget? leading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final PreferredSizeWidget? bottom;
  final FontWeight fontWeight;
  final bool canPop;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: isElevated ? 2 : 0,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      bottom: bottom,
      actions: trailing == null ? null : [trailing!],
      leading: leading??(canPop
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 20,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          : IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu),
            )),
      title: Text(
        title,
        //TODO: update this textStyle
        style: TextStyle(
          fontSize: 20,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}

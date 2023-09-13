import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  final IconData iconData;
  final Color iconColor;
  final Color itemColor;

  final String itemName;
  final double iconSize;
  final void Function() onTap;

  const DrawerItem({
    Key? key,
    required this.iconData,
    required this.itemColor,
    required this.itemName,
    required this.iconSize,
    required this.iconColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        tileColor: Colors.transparent,
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        minLeadingWidth: 0,
        leading: Icon(
          iconData,
          color: iconColor,
          size: iconSize,
        ),
        title: Text(
          itemName,
          // style: TextStyle(
          //   color: itemColor,
          //   fontWeight: FontWeight.w500,
          //   fontSize: 16,
          // ),
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: itemColor,
              ),
        ),
      ),
    );
  }
}
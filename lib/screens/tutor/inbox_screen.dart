import 'package:flutter/material.dart';

import '../../widgets/common/custom_appbar.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({ Key? key }) : super(key: key);

  @override
  _InboxScreenState createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const CustomAppBar(
            title: 'Inbox',
            backgroundColor: Colors.transparent,
            canPop: false,
            centerTitle: true,
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

import '../../widgets/common/custom_appbar.dart';

class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({ Key? key }) : super(key: key);

  @override
  _AssignmentsScreenState createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const CustomAppBar(
            title: 'Assignments',
            backgroundColor: Colors.transparent,
            canPop: false,
            centerTitle: true,
          ),
        ],
      ),
    );
  }
}
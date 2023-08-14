import 'package:flutter/material.dart';

import '../../widgets/common/custom_appbar.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({ Key? key }) : super(key: key);

  @override
  _StudentsScreenState createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const CustomAppBar(
            title: 'Students',
            backgroundColor: Colors.transparent,
            canPop: false,
            centerTitle: true,
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

class GettingStartedScreen extends StatefulWidget {
  const GettingStartedScreen({ Key? key }) : super(key: key);

  @override
  _GettingStartedScreenState createState() => _GettingStartedScreenState();
}

class _GettingStartedScreenState extends State<GettingStartedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Card(
            child: Image.asset('assets/student.png'),
          ),
          Divider(height: 20,),
          Card(
            child: Image.asset('assets/teacher.png'),
          ),
        ],
      ),
    );
  }
}
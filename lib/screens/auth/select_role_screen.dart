import 'package:flutter/material.dart';
import 'package:tutor_app/screens/auth/sign_up_screen.dart';
import 'package:tutor_app/utils/loading_button.dart';
import 'package:tutor_app/widgets/common/custom_appbar.dart';

import '../../models/user.dart';

class SelectRoleScreen extends StatefulWidget {
  const SelectRoleScreen({Key? key}) : super(key: key);

  @override
  _SelectRoleScreenState createState() => _SelectRoleScreenState();
}




class _SelectRoleScreenState extends State<SelectRoleScreen> {
  Size get size => MediaQuery.of(context).size;


  UserRole selectedRole=UserRole.Student;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Select your role',canPop: true, backgroundColor: Colors.transparent,),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Material(
                    color: selectedRole==UserRole.Student?Colors.blue:Colors.white,
                    shape: const CircleBorder(),
                    elevation: selectedRole==UserRole.Student?10:0,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {
                        setState(() {
                          selectedRole=UserRole.Student;
                        });
                      },
                      child: SizedBox(
                          width: double.infinity,
                          child: Hero(
                            tag: UserRole.Student.name,
                            child: Image.asset(
                              'assets/${UserRole.Student.name}.png',
                              height: size.height / 3,
                            ),
                          )),
                    ),
                  ),
                  const Divider(
                    height: 40,
                  ),
                  Material(
                    color: selectedRole==UserRole.Teacher?Colors.blue:Colors.white,
                    shape: const CircleBorder(),
                    elevation: selectedRole==UserRole.Teacher?10:0,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        setState(() {
                          selectedRole=UserRole.Teacher;
                        });
                      },
                      child: SizedBox(
                          width: double.infinity,
                          child: Hero(
                            tag: UserRole.Teacher.name,
                            child: Image.asset(
                              'assets/${UserRole.Teacher.name}.png',
                              height: size.height / 3,
                            ),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Continue as', style: TextStyle(color: Colors.black,fontSize: 18),),
                LoadingButton(buttonText: selectedRole.name, onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (_)=>SignUpScreen(selectedRole: selectedRole,)));}, isLoading: false)
              ],
            ),
          )
        ],
      ),
    );
  }
}

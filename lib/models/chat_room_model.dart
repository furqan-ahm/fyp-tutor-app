import 'package:tutor_app/models/user_model.dart';

class ChatRoom{
  String id;
  bool seen=false;
  //String? roomName;
  //List<AppUser> students;
  AppUser student;

  //String get name=>roomName??students.fold('', (previousValue, element) => previousValue+element.name+', ');


  //ChatRoom({required this.id, required this.students, this.roomName});
  ChatRoom({required this.id, required this.student,});

}
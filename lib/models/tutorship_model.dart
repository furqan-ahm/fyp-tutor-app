import 'package:tutor_app/models/tutor_model.dart';
import 'package:tutor_app/models/user_model.dart';

class Tutorship{
  String id;
  AppUser student;
  Tutor tutor;
  double hourlyRate=2500;
  

  Tutorship({required this.student, required this.tutor, required this.id});



  static Tutorship fromMap(String id, Map data) {
    print('here');
    return Tutorship(student: AppUser.fromMap(data['student']), tutor: Tutor.fromMap(data['tutor']), id: id);
  }


}
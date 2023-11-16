import 'package:tutor_app/models/tutor_model.dart';
import 'package:tutor_app/models/user_model.dart';

class Tutorship {
  String id;
  AppUser student;
  Tutor tutor;
  AppUser tutorUser;
  double hourlyRate = 2500;

  Tutorship({required this.student, required this.tutor, required this.id, required this.tutorUser});

  static Tutorship fromMap(String id, Map data) {
    return Tutorship(
        student: AppUser.fromMap(data['student']),
        tutor: Tutor.fromMap(data['tutor']),
        tutorUser: AppUser.fromMap(data['tutor']),
        id: id);
  }
}

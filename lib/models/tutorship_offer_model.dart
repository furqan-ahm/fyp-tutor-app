import 'package:tutor_app/models/user_model.dart';

class TutorshipOffer {
  String id;

  AppUser student;
  double price = 2000;

  bool accepted;

  TutorshipOffer(
      {required this.student, required this.id, required this.accepted});

  static TutorshipOffer fromMap(String id, Map data) => TutorshipOffer(
      id: id,
      student: AppUser.fromMap(
        data['student'],
      ),
      accepted: data['accepted'] ?? false);
}

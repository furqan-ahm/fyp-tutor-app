import 'package:tutor_app/models/user_model.dart';

class Tutor {
  String name;
  String uid;
  String institute;
  String degree;
  String photoURL;

  double rating;

  List<String> subjects;

  List<String> offerUIDs;

  Tutor(
      {required this.uid,
      required this.name,
      required this.degree,
      required this.photoURL,
      required this.institute,
      required this.subjects,
      required this.offerUIDs,
      this.rating = 0});

  static Tutor fromMap(Map data) {
   
    return Tutor(
      uid: data['uid'],
      photoURL: data['photoUrl']??guestUser.getProfilePictureURL,
      name: data['name'],
      degree: data['education_level'],
      institute: data['institute']??'',
      offerUIDs: [...(data['offers_uid']??[])],
      subjects: [...((data['subjects'] as List?)??[])],    
    );
  }

  String get degreeString => degree.split(' ').first;
}

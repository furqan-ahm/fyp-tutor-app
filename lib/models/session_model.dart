import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutor_app/constants/constants.dart';
import 'package:tutor_app/models/user_model.dart';

class Session {
  String id;
  String title;
  AppUser tutor;
  AppUser student;
  Duration duration;
  DateTime time;
  bool isLive;
  String? media;

  Session(
      {required this.id,
      required this.tutor,
      required this.duration,
      required this.title,
      required this.student,
      required this.isLive,
      this.media,
      required this.time});

  bool get isActiveTime =>
      DateTime.now().isAfter(time) &&
      DateTime.now().isBefore(time.add(duration));

  bool get isExpired => DateTime.now().isAfter(time.add(duration));

  String get timeString => isLive
      ? "LIVE RIGHT NOW!"
      : "${time.day} ${months[time.month]}, ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";

  static Session fromMap(String id, Map<String, dynamic> data) {
    return Session(
        id: id,
        isLive: data['isLive'] ?? false,
        title: data['title'],
        tutor: AppUser.fromMap(data['tutor']),
        student: AppUser.fromMap(data['student']),
        media: data['media'],
        duration: Duration(minutes: data['duration']),
        time: (data['time'] as Timestamp).toDate());
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutor_app/constants/constants.dart';
import 'package:tutor_app/models/user_model.dart';

class Submission {
  String id;
  String? detail;
  Map? attached;
  AppUser student;
  DateTime submissionTime;
  bool? approved;


  bool get notChecked=>approved==null;

  Submission(
      {required this.id,
      this.detail,
      this.attached,
      required this.student,
      this.approved,
      required this.submissionTime});

  static Submission fromMap(String id, Map<String, dynamic> data) => Submission(
      id: id,
      student: AppUser.fromMap(data['student']),
      approved: data['approved'],
      submissionTime: (data["time"] as Timestamp).toDate(),
      detail: data['details'],
      attached: data['attachedFile']);
}

class Assignment {
  String id;

  String name;
  String? details;
  double? points;
  double? obtained;
  AppUser student;
  AppUser tutor;
  Map? attachedFiles;
  DateTime time;
  DateTime deadline;
  bool closed;
  String? submitID;
  bool submitted;


  bool get hasAttachment=>attachedFiles!=null;

  String get timeString =>
      "${deadline.day} ${months[deadline.month]}, ${deadline.hour.toString().padLeft(2, '0')}:${deadline.minute.toString().padLeft(2, '0')}";

  Assignment(
      {required this.id,
      required this.name,
      required this.student,
      required this.details,
      required this.closed,
      this.submitID,
      this.obtained,
      required this.tutor,
      required this.submitted,
      required this.deadline,
      required this.points,
      required this.attachedFiles,
      required this.time});

  static Assignment fromMap(String id, Map<String, dynamic> data) {
    return Assignment(
      id: id,
      name: data['title'],
      // students: (data['students'] as List<Map<String, dynamic>>)
      //     .map((e) => AppUser.fromMap(e))
      //     .toList(),
      student: AppUser.fromMap(data['student']),
      points: data['points']==null?null:data['points']*1.0,
      submitted: data['submitted'] ?? false,
      submitID: data['submitID'],
      obtained: data['obtained'],
      details: data['details'],
      closed: data['approved'] ?? false,
      tutor: AppUser.fromMap(data['tutor']),
      attachedFiles: data['attachedFile'],
      deadline: (data['deadline'] as Timestamp).toDate(),
      time: (data["time"] as Timestamp).toDate());
  }
}

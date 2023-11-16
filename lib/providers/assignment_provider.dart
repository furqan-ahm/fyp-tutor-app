import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_app/models/assignment_model.dart';
import 'package:tutor_app/models/user_model.dart';
import 'package:tutor_app/repository/firebase_firestore_repo.dart';

class AssignmentProvider extends ChangeNotifier{


  static AssignmentProvider of(BuildContext context, {bool listen=false}){
    return Provider.of<AssignmentProvider>(context, listen: listen);
  }

  Future<bool> createAssignment(String title, AppUser tutor, AppUser student, DateTime deadline, {String? details, Map? attached, double? points}){
    return FirestoreRepository.createAssignment(
      {
        'title':title,
        'details':details,
        'deadline':Timestamp.fromDate(deadline),
        'points':points,
        'attachedFile':attached,
        'time':Timestamp.now(),
        'tutor':tutor.toMap(),
        'student':student.toMap(),
        'concerned':[tutor.uid,student.uid]
      }
    );
  }


  Future<bool> submitAssignment(String assignmentID, String detail, Map attached, AppUser student){
    return FirestoreRepository.submitAssignment(assignmentID,
      {
        'details':detail,
        'attachedFile':attached,
        'student':student.toMap(),
        'time':DateTime.now(),
        'studentID':student.uid
      }
    );
  }

  Future<bool> gradeAndCloseAssignment(Assignment assignment, double obtPoints) {
    return FirestoreRepository.closeAssignment(assignment, obtPoints:obtPoints);
  }


}
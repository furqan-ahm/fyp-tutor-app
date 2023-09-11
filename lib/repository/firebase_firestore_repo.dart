import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:tutor_app/models/session_model.dart';
import 'package:tutor_app/models/tutorship_model.dart';
import 'package:tutor_app/models/tutorship_offer_model.dart';
import 'package:tutor_app/models/user_model.dart';
import '../models/tutor_model.dart';
import '../resources/firebase_firestore_collections.dart';

class FirestoreRepository {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<dynamic> setNotificationToken(String uid, String token) async {
    await _firestore
        .collection(FirebaseCollections.usersCollection)
        .doc(uid)
        .update({'notification_token': token});
  }

  static Future<dynamic> sendTutorshipOffer(AppUser user, Tutor tutor) async {
    await updateUserData(
        uid: tutor.uid, key: 'offers_uid', value: tutor.offerUIDs);
    await _firestore
        .collection(FirebaseCollections.usersCollection)
        .doc(tutor.uid)
        .collection('offers')
        .doc(user.uid)
        .set({
      'student': user.toMap(),
    });
  }

  static Future<dynamic> createSession(Map<String, dynamic> data) async {
    try {
      var res=await _firestore.collection('sessions').add(data);
      var doc=(await res.get());
      return Session.fromMap(doc.id, doc.data()!);
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  static Stream<List<TutorshipOffer>> getTutorshipOffersStream(String tutorID) {
    return _firestore
        .collection(FirebaseCollections.usersCollection)
        .doc(tutorID)
        .collection('offers')
        .snapshots()
        .map((event) => event.docs
            .map((e) => TutorshipOffer.fromMap(e.id, e.data()))
            .toList());
  }

  static Stream<List<Tutorship>> getTutorshipsStream(String uid) {
    return _firestore
        .collection(FirebaseCollections.tutorshipCollection)
        .where('members', arrayContains: uid)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => Tutorship.fromMap(e.id, e.data())).toList());
  }

  static Future<List<AppUser>> getStudents(String uid) async {
    return (await _firestore
            .collection(FirebaseCollections.tutorshipCollection)
            .where('members', arrayContains: uid)
            .get())
        .docs
        .map((e) => AppUser.fromMap(e.data()['student']))
        .toList();
  }

  // static deleteTutorshipOffer(String tutorID, String offerID){

  // }

  static Future<bool> startTutorship(
      String offerID, AppUser student, AppUser tutor) async {
    try {
      await _firestore
          .collection(FirebaseCollections.usersCollection)
          .doc(tutor.uid)
          .collection('offers')
          .doc(offerID)
          .update({'accepted': true});
      await _firestore.collection(FirebaseCollections.tutorshipCollection).add({
        'members': [student.uid, tutor.uid],
        'student': student.toMap(),
        'tutor': tutor.toMap(),
        'start_date': Timestamp.now(),
        'subjects': student.subjects
      });
    } catch (e) {
      print(e);
      return false;
    }

    return true;
  }

  static Stream<List<Session>> getSessionStream(String uid) => _firestore
      .collection('sessions')
      .where('participants', arrayContains: uid)
      .snapshots()
      .map((event) =>
          event.docs.map((e) => Session.fromMap(e.id, e.data())).toList());

  static Future<dynamic> getSuggestedTutors(AppUser student) async =>
      (await _firestore
              .collection(FirebaseCollections.usersCollection)
              .where('type', isEqualTo: 0)
              .where('subjects', arrayContainsAny: student.subjects)
              .get())
          .docs
          .where((element) => [...(element.data()['student_ids'] ?? [])].fold(
              true,
              (previousValue, element) =>
                  previousValue && element != student.uid))
          .map((e) => Tutor.fromMap(e.data()))
          .toList();

  static Future<dynamic> isRegistered(String phoneNumber) async {
    dynamic result = '';
    try {
      await _firestore
          .collection(FirebaseCollections.usersCollection)
          .where("phone", isEqualTo: phoneNumber)
          .where('numberVerified', isEqualTo: true)
          .get()
          .then((value) {
        // print(
        //     'value inside the firestore checking value: ${value.docs.length}');
        if (value.docs.isNotEmpty) {
          // print('isNotEmpty');
          result = true;
        } else {
          result = false;
        }
      });
    } catch (e) {
      debugPrint(e.toString());

      result = e.toString();
    }

    return result;
  }

  //UPDATING USER DATA
  static Future<dynamic> addOrUpdateUserData({
    required String uid,
    required String key,
    required dynamic value,
  }) async {
    try {
      final userCollection =
          _firestore.collection(FirebaseCollections.usersCollection);
      final userDocID = await userCollection
          .where('uid', isEqualTo: uid)
          .get()
          .then((snapshot) => snapshot.docs.first.id);

      //this will add if the new value is not found, and updates the already existing data.
      String result = await userCollection
          .doc(userDocID)
          .set({key: value}, SetOptions(merge: true)).then((value) {
        return 'updated';
      }).onError((error, stackTrace) {
        return error.toString();
      });

      return result;
    } catch (e) {
      return e.toString();
    }
  }

  static Future<dynamic> updateAll({
    required String uid,
    required Map<String, dynamic> valueMap,
  }) async {
    try {
      final userCollection =
          _firestore.collection(FirebaseCollections.usersCollection);
      final userDocID = await userCollection
          .where('uid', isEqualTo: uid)
          .get()
          .then((snapshot) => snapshot.docs.first.id);

      //this will add if the new value is not found, and updates the already existing data.
      String result = await userCollection
          .doc(userDocID)
          .set(valueMap, SetOptions(merge: true))
          .then((value) {
        return 'updated';
      }).onError((error, stackTrace) {
        return error.toString();
      });

      return result;
    } catch (e) {
      return e.toString();
    }
  }

  static Future<dynamic> updateUserData({
    required String uid,
    required String key,
    required dynamic value,
  }) async {
    try {
      final userCollection =
          _firestore.collection(FirebaseCollections.usersCollection);
      final userDocID = await userCollection
          .where('uid', isEqualTo: uid)
          .get()
          .then((snapshot) => snapshot.docs.first.id);

      // print(user.data());
      String result = await userCollection
          .doc(userDocID)
          .update({key: value}).then((value) {
        return 'updated';
      }).onError((error, stackTrace) {
        return error.toString();
      });

      return result;
    } catch (e) {
      return e.toString();
    }
  }

  static Future<dynamic> deleteUserData(
      {required String uid,
      required String key,
      required String keyName}) async {
    try {
      final userCollection =
          _firestore.collection(FirebaseCollections.usersCollection);
      final userDocID = await userCollection
          .where('uid', isEqualTo: uid)
          .get()
          .then((snapshot) => snapshot.docs.first.id);

      String result = await userCollection.doc(userDocID).set({
        key: {
          keyName: FieldValue.delete(),
        }
      }, SetOptions(merge: true)).then((value) {
        return 'deleted';
      }).onError((error, stackTrace) {
        return error.toString();
      });

      return result;
    } catch (e) {
      return e.toString();
    }
  }
}

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import '../resources/firebase_firestore_collections.dart';

class FirestoreRepository {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  

  static Future<dynamic> setNotificationToken(String uid, String token)async{
    await _firestore.collection(FirebaseCollections.usersCollection).doc(uid).update({'notification_token':token});
  }

  static Future<dynamic> isRegistered(String phoneNumber) async {
    dynamic result = '';
    try {
      await _firestore
          .collection(FirebaseCollections.usersCollection)
          .where("phone", isEqualTo: phoneNumber).where('numberVerified', isEqualTo: true)
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
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

final storageRef = FirebaseStorage.instance;

Future<String?> uploadProfileImage(String uid, String imagePath) async {
  try {
    File imageFile = File(imagePath);

    final profilePicRef = storageRef.ref().child('users/$uid/profile_pic');

    await profilePicRef.putFile(imageFile);
    final imageURL = await profilePicRef.getDownloadURL();
    return imageURL;
  } catch (e) {
    print(e);
  }

  return null;
}
Future<String?> uploadFile(String uid, File file) async {
  try {

    final ref = storageRef.ref().child('users/$uid/${file.path.split('/').last}');

    await ref.putFile(file);
    final downloadURL = await ref.getDownloadURL();
    return downloadURL;
  } catch (e) {
    print(e);
  }

  return null;
}

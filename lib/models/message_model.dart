import 'package:cloud_firestore/cloud_firestore.dart';

import '/models/user_model.dart';

class Message {
  final AppUser? sender;
  final AppUser? reciever;
  final String? text;
  final bool? unread;
  final DateTime? time;

  Message({
    required this.sender,
    required this.reciever,
    required this.text,
    required this.unread,
    required this.time,
  });

  static Message fromMap(Map<String, dynamic> mapData) => Message(
        sender: AppUser.fromMap(mapData['sender']),
        reciever: AppUser.fromMap(mapData['receiver']),
        text: mapData['text'] ?? 'Error',
        unread: mapData['unread'] ?? false,
        time: (mapData['time'] as Timestamp).toDate(),
      );

  toMap() {
    return {
      'sender': sender!.toMap(),
      'receiver': reciever!.toMap(),
      'senderId': sender!.uid,
      'text': text,
      'unread': unread,
      'time': time?.toUtc()
    };
  }
}
import 'dart:async';
// ignore: unused_import
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';
import 'package:tutor_app/models/session_model.dart';
import 'package:tutor_app/providers/auth_provider.dart';
import 'package:tutor_app/repository/firebase_firestore_repo.dart';

import '../models/user_model.dart';

class SessionProvider extends ChangeNotifier {
  Stream<List<Session>> getSessionStream(BuildContext context) =>
      FirestoreRepository.getSessionStream(
          AuthProvider.of(context).currentUser.uid);

  Future<dynamic> createSession(String title, AppUser student, AppUser tutor,
      DateTime time, int duration) async {

    return await FirestoreRepository.createSession({
      'title': title,
      'participants': [tutor.uid, student.uid],
      'tutor': tutor.toMap(),
      'student': student.toMap(),
      'duration': duration,
      'time': Timestamp.fromDate(time),
      'endTime': Timestamp.fromDate(time.add(Duration(minutes: duration)))
    });
  }

  void joinMeeting(Session session, AppUser currentUser) {
    JitsiMeetWrapper.joinMeeting(
        options: JitsiMeetingOptions(
            roomNameOrUrl: session.id,
            subject: session.title,
            userDisplayName: currentUser.name,
            userAvatarUrl: currentUser.getProfilePictureURL,
            userEmail: currentUser.email,
            serverUrl: 'https://meet.thecodingintern.ninja'),
        listener: JitsiMeetingListener(
          onConferenceJoined: (details) {
            if (currentUser.isTutor)
              FirestoreRepository.toggleSessionLive(session.id, true);
          },
          onClosed: () {
            if (currentUser.isTutor)
              FirestoreRepository.toggleSessionLive(session.id, false);
          },
          onParticipantJoined: (email, name, role, participantId) {
            FirestoreRepository.addMeetingLog(
                session.id, '$name|$email|$participantId joined the meeting');
          },
          onParticipantLeft: (participantId) =>
              '$participantId left the meeting',
          onChatMessageReceived: (senderId, message, isPrivate) {
            if (isPrivate) {
              var split = message.split(':');
              var link = split[1] + ':' + split[2];
              FirestoreRepository.addSessionMedia(session.id, link);
              FirestoreRepository.addMeetingLog(
                  session.id, 'privateMessage: $message');
            } else
              FirestoreRepository.addMeetingLog(
                  session.id, '$senderId said: $message');
          },
        ));
  }
}

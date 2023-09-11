import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:tutor_app/models/session_model.dart';
import 'package:tutor_app/providers/auth_provider.dart';
import 'package:tutor_app/repository/firebase_firestore_repo.dart';
import 'package:tutor_app/repository/firebase_storage_repo.dart';

import '../models/user_model.dart';

class SessionProvider extends ChangeNotifier {

  late Socket _socket;
  Map<String, dynamic> configuration = {};

  final StreamController _rawAnswerStreamController = StreamController();
  final StreamController _rawOfferStreamController = StreamController();

  SessionProvider(){
     _socket=io(
      true?'http://10.0.2.2:3000':'add server here',
      OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build());
    
    //establishConnection();
  }


  establishConnection(String id,{Function()? onConnect}){
    _socket.onConnect((data){
      print('connected');
      _socket.emit('set-id', id);
      onConnect!=null?onConnect():null;
    });
    _socket.connect();
  }







  Stream<List<Session>> getSessionStream(BuildContext context)=>FirestoreRepository.getSessionStream(AuthProvider.of(context).currentUser.uid);


  Future<dynamic> createSession(String title, AppUser student, Map files, AppUser tutor, DateTime time, int duration)async{
    Map media={};
    if(files.isNotEmpty){
      for(var entry in files.entries){
          media[entry.key]=await uploadFile(tutor.uid, entry.value);
      }
    }

    return await FirestoreRepository.createSession(
      {
        'title':title,
        'participants':[tutor.uid, student.uid],
        'tutor':tutor.toMap(),
        'student':student.toMap(),
        'media':media,
        'duration':duration,
        'time':Timestamp.fromDate(time)
      }
    );


  }

}

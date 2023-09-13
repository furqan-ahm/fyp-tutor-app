import 'package:flutter/material.dart';
import 'package:tutor_app/models/tutorship_offer_model.dart';
import 'package:tutor_app/providers/auth_provider.dart';
import 'package:tutor_app/repository/firebase_firestore_repo.dart';

import '../models/tutor_model.dart';
import '../models/tutorship_model.dart';
import '../models/user_model.dart';

class TutorshipProvider extends ChangeNotifier{

  bool loading=false;


  List<Tutor> suggestedTutors=[];

  Stream<List<TutorshipOffer>> offerStream(BuildContext context)=>FirestoreRepository.getTutorshipOffersStream(AuthProvider.of(context).currentUser.uid);



  Stream<List<Tutorship>> tutorshipStreams(BuildContext context)=>FirestoreRepository.getTutorshipsStream(AuthProvider.of(context).currentUser.uid);



  Future<List<AppUser>> getStudents(BuildContext context)=>FirestoreRepository.getStudents(AuthProvider.of(context).currentUser.uid);

  Future createTutoship(String offerID, AppUser student, AppUser tutor)async{
    return await FirestoreRepository.startTutorship(offerID, student, tutor);
  }

  loadSuggestedTutors(BuildContext context){
    loading=true;
    notifyListeners();
    var user=AuthProvider.of(context).currentUser;
    print(user.subjects);
    FirestoreRepository.getSuggestedTutors(user).then((value){
      if(value is List<Tutor>){
        suggestedTutors=value;
        loading=false;
        notifyListeners();
      }
    });
  }



  sendTutorshipOffer(AppUser user, Tutor tutor){
    tutor.offerUIDs.add(user.uid);
    FirestoreRepository.sendTutorshipOffer(user, tutor);
    notifyListeners();
  }


}
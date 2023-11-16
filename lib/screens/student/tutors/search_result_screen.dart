import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_app/models/tutor_model.dart';
import 'package:tutor_app/providers/auth_provider.dart';
import 'package:tutor_app/providers/tutorship_provider.dart';
import 'package:tutor_app/repository/firebase_firestore_repo.dart';
import 'package:tutor_app/theme.dart';
import 'package:tutor_app/widgets/tutors/searched_tutor_card.dart';

class SearchResultScreen extends StatefulWidget {
  const SearchResultScreen({ Key? key, required this.subject}) : super(key: key);

  final String subject;

  @override
  _SearchResultScreenState createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {


  List<Tutor> tutors=[];

  bool loading=true;


  @override
  void initState() {
    super.initState();
    FirestoreRepository.getRelevantTutors(widget.subject, AuthProvider.of(context).currentUser).then((value){
      setState(() {
        loading=false;
        tutors=value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Consumer<TutorshipProvider>(
            builder: (context,_,__) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.subject}',
                            style: theme.textTheme.headlineMedium
                                ?.copyWith(fontSize: 18),
                          ),
                          Text('Search Results',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 19)),
                          const SizedBox(height: 5,),
                          tutors.isEmpty?const Text('It seems that there are no teachers teaching that subject at the moment'):ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: tutors.length,
                              itemBuilder: (context, index)=>SearchedTutorCard(tutor: tutors[index]),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}
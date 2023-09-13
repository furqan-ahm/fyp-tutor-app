import 'package:flutter/material.dart';
import 'package:tutor_app/screens/tutor/students/offers_screen.dart';

class TutorshipOffersTile extends StatefulWidget {
  const TutorshipOffersTile({Key? key}) : super(key: key);

  @override
  _TutorshipOffersTileState createState() => _TutorshipOffersTileState();
}

class _TutorshipOffersTileState extends State<TutorshipOffersTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          leading: const CircleAvatar(
            foregroundColor: Colors.white,
            backgroundColor: Colors.orangeAccent,
            child: Icon(Icons.question_mark),
          ),
          title: const Text('Tutorship Offers'),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder:(context) => const OffersScreen(),));
          },
        ),
      ),
    );
  }
}

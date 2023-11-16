import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tutor_app/constants/colors.dart';
import 'package:tutor_app/models/tutorship_model.dart';
import 'package:tutor_app/providers/assignment_provider.dart';
import 'package:tutor_app/repository/firebase_firestore_repo.dart';
import 'package:tutor_app/theme.dart';
import 'package:tutor_app/widgets/common/custom_button.dart';

class EndTutorship extends StatefulWidget {
  const EndTutorship({Key? key, required this.tutorship, this.isStudent=true}) : super(key: key);

  final Tutorship tutorship;

  final bool isStudent;

  @override
  _EndTutorshipState createState() => _EndTutorshipState();
}

class _EndTutorshipState extends State<EndTutorship> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Ending Tutorship?",
                style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: primaryColor),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Container(
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: primaryColor),
                    child: CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                          widget.tutorship.tutorUser.getProfilePictureURL,
                        ))),
              ),
              Text(
                widget.tutorship.tutor.name,
                style: theme.textTheme.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(
                height: 15,
              ),
              RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  
                },
              ),
              CustomButton(
                buttonText: 'Confirm',
                fullWidth: true,
                onPressed: () async {
                  FirestoreRepository.endTutorship(widget.tutorship.id).then((value) => Navigator.pop(context));
                },
              ),
              CustomButton(
                buttonText: 'Cancel',
                onPressed: () async {
                  Navigator.pop(context, false);
                },
                fullWidth: true,
                backgroundColor: Colors.transparent,
                foregroundColor: primaryColor,
                elevation: 0,
              ),
            ],
          ),
        ));
  }
}

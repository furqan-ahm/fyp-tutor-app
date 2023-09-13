import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_app/providers/auth_provider.dart';
import 'package:tutor_app/providers/tutorship_provider.dart';

import '../../constants/colors.dart';
import '../../models/tutor_model.dart';
import '../../theme.dart';

class SearchedTutorCard extends StatelessWidget {
  const SearchedTutorCard({Key? key, required this.tutor}) : super(key: key);

  final Tutor tutor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Material(
          borderRadius: BorderRadius.circular(11),
          color: Colors.white,
          elevation: 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: primaryColor),
                        child: CircleAvatar(backgroundImage: NetworkImage(tutor.photoURL,))
                      ),
                    ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          tutor.name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(fontSize: 18),
                        ),
                        const Spacer(),
                        Text(
                          'RS. 2500/hour',
                          style: theme.textTheme.headlineSmall
                              ?.copyWith(fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          tutor.degreeString,
                          style: theme.textTheme.headlineSmall
                              ?.copyWith(fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          tutor.institute,
                          style: theme.textTheme.headlineSmall
                              ?.copyWith(fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    Text(
                      tutor.subjects.join(', '),
                      style:
                          theme.textTheme.headlineSmall?.copyWith(fontSize: 14),
                    ),
                  ],
                ),
              ),
              Material(
                color: tutor.offerUIDs.contains(AuthProvider.of(context).currentUser.uid)?greyButtonColor:primaryColor,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(11),
                    bottomRight: Radius.circular(11)),
                child: InkWell(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(11),
                      bottomRight: Radius.circular(11)),
                  onTap: tutor.offerUIDs.contains(AuthProvider.of(context).currentUser.uid)?null:() {
                    Provider.of<TutorshipProvider>(context, listen: false).sendTutorshipOffer(AuthProvider.of(context).currentUser, tutor);
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Center(
                        child: Text(
                          tutor.offerUIDs.contains(AuthProvider.of(context).currentUser.uid)?'Already Applied':'Apply for Tutorship',
                          style: TextStyle(
                              fontSize: 14, color: tutor.offerUIDs.contains(AuthProvider.of(context).currentUser.uid)?Colors.black:headingColor),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

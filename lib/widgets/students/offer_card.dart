import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_app/models/tutor_model.dart';
import 'package:tutor_app/models/tutorship_offer_model.dart';
import 'package:tutor_app/models/user_model.dart';
import 'package:tutor_app/providers/auth_provider.dart';
import 'package:tutor_app/providers/tutorship_provider.dart';
import 'package:tutor_app/widgets/common/custom_button.dart';

import '../../constants/colors.dart';
import '../../theme.dart';

class OfferCard extends StatelessWidget {
  const OfferCard({Key? key, required this.offer}) : super(key: key);


  final TutorshipOffer offer;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Material(
          borderRadius: BorderRadius.circular(11),
          color: Colors.white,
          elevation: 2,
          child: Padding(
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
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: primaryColor),
                        child: Image.network(offer.student.getProfilePictureURL, width: 28,)
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      offer.student.name,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(fontSize: 15),
                    ),
                    const Spacer(),
                     Text(
                          'RS. ${offer.price}/hour',
                          style: theme.textTheme.headlineSmall
                              ?.copyWith(fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'English, Urdu',
                      style:
                          theme.textTheme.headlineSmall?.copyWith(fontSize: 14),
                    ),
                    CustomButton(
                      buttonText: offer.accepted?'Accepted':'Accept',
                      backgroundColor: offer.accepted?greyButtonColor:primaryColor,
                      foregroundColor: offer.accepted?Colors.black:Colors.white,
                      onPressed: offer.accepted?null:()async{
                        return await Provider.of<TutorshipProvider>(context, listen: false).createTutoship(offer.id, offer.student, AuthProvider.of(context).currentUser);
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

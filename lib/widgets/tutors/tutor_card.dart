import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:tutor_app/models/tutorship_model.dart';

import '../../constants/colors.dart';
import '../../theme.dart';

class TutorCard extends StatelessWidget {
  const TutorCard({Key? key, required this.tutorship}) : super(key: key);


  final Tutorship tutorship;

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
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: primaryColor),
                        child: CircleAvatar(backgroundImage: NetworkImage(tutorship.tutor.photoURL,))
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      tutorship.tutor.name,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(fontSize: 15),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        IconsaxOutline.menu,
                        color: accentColor,
                      ),
                    )
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
                    Material(
                      color: primaryColor,
                      borderRadius: const BorderRadius.all(Radius.circular(11)),
                      child: InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(11)),
                        onTap: () {},
                        child: const Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 5),
                          child: Text(
                            'Message',
                            style: const TextStyle(
                                fontSize: 14, color: headingColor),
                          ),
                        ),
                      ),
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

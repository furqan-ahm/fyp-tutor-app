import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:tutor_app/models/tutorship_model.dart';
import 'package:tutor_app/providers/auth_provider.dart';
import 'package:tutor_app/repository/firebase_firestore_repo.dart';
import 'package:tutor_app/screens/tutor/inbox/chat_screen.dart';
import 'package:tutor_app/widgets/common/end_tutorship.dart';

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
                          child: CircleAvatar(
                              backgroundImage: NetworkImage(
                            tutorship.tutor.photoURL,
                          ))),
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
                    MenuAnchor(
                        builder: (BuildContext context,
                            MenuController controller, Widget? child) {
                          return IconButton(
                            onPressed: () {
                              if (controller.isOpen) {
                                controller.close();
                              } else {
                                controller.open();
                              }
                            },
                            icon: const Icon(
                              IconsaxOutline.menu,
                              color: accentColor,
                            ),
                          );
                        },
                        menuChildren: [
                          MenuItemButton(
                            onPressed: () {
                              showDialog(context: context, builder:(context) => EndTutorship(tutorship: tutorship),);
                            },
                            child: const Text('End Tutorship'),
                          ),
                         
                        ]),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      tutorship.tutor.subjects
                          .reduce((value, element) => '$value, $element'),
                      style:
                          theme.textTheme.headlineSmall?.copyWith(fontSize: 14),
                    ),
                    Material(
                      color: primaryColor,
                      borderRadius: const BorderRadius.all(Radius.circular(11)),
                      child: InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(11)),
                        onTap: () {
                          FirestoreRepository.createChatRoom(
                                  AuthProvider.of(context).currentUser.uid,
                                  tutorship.tutor.uid)
                              .then((value) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                      chatRoom: value,
                                      otherUser: tutorship.tutorUser),
                                ));
                          });
                        },
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

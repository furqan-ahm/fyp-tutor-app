import 'package:flutter/material.dart';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:tutor_app/providers/auth_provider.dart';
import 'package:tutor_app/providers/session_provider.dart';
import 'package:tutor_app/repository/firebase_firestore_repo.dart';
import 'package:tutor_app/screens/tutor/sessions/session_screen.dart';

import 'package:flutter/services.dart';
import 'package:tutor_app/utils/utils.dart';

import '../constants/colors.dart';
import '../constants/constants.dart';
import '../models/session_model.dart';
import '../theme.dart';
import 'common/custom_button.dart';

class SessionList extends StatefulWidget {
  const SessionList({Key? key, this.isStudent = false}) : super(key: key);

  final bool isStudent;
  @override
  _SessionListState createState() => _SessionListState();
}

class _SessionListState extends State<SessionList> {



  SessionProvider get sessionProv=>Provider.of<SessionProvider>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Session>>(
        stream: Provider.of<SessionProvider>(context).getSessionStream(context),
        builder: (context, snapshot) {
          List<Session> relevantSessions =
              snapshot.data?.where((element) => !element.isExpired).toList() ??
                  [];
          if (relevantSessions.isEmpty) {
            return Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                color: bodyTextColor.withOpacity(0.07),
                child: RichText(
                  text: TextSpan(
                      text: 'Your scheduled sessions',
                      style: const TextStyle(fontSize: 16, color: primaryColor),
                      children: [
                        TextSpan(
                            text: widget.isStudent
                                ? ' will appear here when a meeting is scheduled or live.'
                                : ' will appear here when a meeting is scheduled or started.',
                            style: const TextStyle(color: Colors.black)),
                      ]),
                ));
          }

          return ListView.builder(
            itemCount: relevantSessions.length,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            shrinkWrap: true,
            primary: false,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Material(
                borderRadius: BorderRadius.circular(11),
                color: Colors.white,
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            relevantSessions[index].title,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          relevantSessions[index].isLive
                              ? Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                      gradient: gradient,
                                      shape: BoxShape.circle),
                                )
                              : const SizedBox.shrink(),
                          const Spacer(),
                          MenuAnchor(
                                  builder: (BuildContext context,
                                      MenuController controller,
                                      Widget? child) {
                                    return IconButton(
                                      onPressed: () {
                                        if (controller.isOpen) {
                                          controller.close();
                                        } else {
                                          controller.open();
                                        }
                                      },
                                      icon: const Icon(Icons.more_horiz),
                                      tooltip: 'Show menu',
                                    );
                                  },
                                  menuChildren: [
                                      MenuItemButton(
                                        onPressed: relevantSessions[index].isLive?() {
                                          Clipboard.setData(ClipboardData(text: relevantSessions[index].id)).then((value) => Utils.showSnackbar('Meeting Code Copied!', context));
                                        }:null,
                                        child: const Text('Copy Meeting Code'),
                                      ),
                                      widget.isStudent?const SizedBox.shrink():MenuItemButton(
                                        onPressed: () {
                                          FirestoreRepository.cancelSession(relevantSessions[index].id);
                                        },
                                        child: const Text('Cancel/End'),
                                      ),
                                    ]),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                    text: widget.isStudent
                                        ? "Teacher: "
                                        : "Student: ",
                                    style: theme.textTheme.headlineSmall
                                        ?.copyWith(fontSize: 14),
                                    children: [
                                      TextSpan(
                                          text: widget.isStudent
                                              ? snapshot.data![index].tutor.name
                                              : snapshot
                                                  .data![index].student.name,
                                          style: const TextStyle(
                                              color: primaryColor))
                                    ]),
                              ),
                              RichText(
                                text: TextSpan(
                                    text: "Time: ",
                                    style: theme.textTheme.headlineSmall
                                        ?.copyWith(fontSize: 14),
                                    children: [
                                      TextSpan(
                                          text: relevantSessions[index]
                                              .timeString,
                                          style: const TextStyle(
                                              color: primaryColor))
                                    ]),
                              ),
                            ],
                          ),
                          relevantSessions[index].isLive ||
                                  (!widget.isStudent &&
                                      relevantSessions[index].isActiveTime)
                              ? FloatingActionButton.extended(
                                  onPressed: () {
                                    sessionProv.joinMeeting(relevantSessions[index], AuthProvider.of(context).currentUser);
                                  },
                                  label: widget.isStudent
                                      ? const Text(' Join ')
                                      : const Text('Start'),
                                  elevation: 0,
                                  heroTag: relevantSessions[index].id,
                                )
                              : const SizedBox.shrink()
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

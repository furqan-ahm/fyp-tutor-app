import 'package:flutter/material.dart';
import 'package:tutor_app/constants/colors.dart';
import 'package:tutor_app/models/session_model.dart';
import 'package:tutor_app/providers/auth_provider.dart';
import 'package:tutor_app/repository/firebase_firestore_repo.dart';
import 'package:tutor_app/screens/tutor/sessions/logs_screen.dart';
import 'package:tutor_app/theme.dart';
import 'package:tutor_app/widgets/common/max_sized_container.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SessionHistoryScreen extends StatefulWidget {
  const SessionHistoryScreen({Key? key}) : super(key: key);

  @override
  _SessionHistoryScreenState createState() => _SessionHistoryScreenState();
}

class _SessionHistoryScreenState extends State<SessionHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
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
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Session History',
                      style: theme.textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold, fontSize: 19)),
                ),
                const SizedBox(
                  height: 15,
                ),
                StreamBuilder(
                  stream: FirestoreRepository.getSessionHistoryStream(
                      AuthProvider.of(context).currentUser.uid),
                  builder: (context, snapshot) {
                    List<Session> relevantSessions = snapshot.data ?? [];
                    if (relevantSessions.isEmpty) {
                      return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 24, horizontal: 16),
                          color: bodyTextColor.withOpacity(0.07),
                          child: RichText(
                            text: const TextSpan(
                              text: 'No sessions in history',
                              style: TextStyle(fontSize: 16, color: primaryColor),
                            ),
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
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            relevantSessions[index].title,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall!
                                                .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
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
                                        ],
                                      ),
                                      const SizedBox(height: 15),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                    text: "Student: ",
                                                    style: theme
                                                        .textTheme.headlineSmall
                                                        ?.copyWith(fontSize: 14),
                                                    children: [
                                                      TextSpan(
                                                          text: snapshot
                                                              .data![index]
                                                              .student
                                                              .name,
                                                          style: const TextStyle(
                                                              color:
                                                                  primaryColor))
                                                    ]),
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                    text: "Time: ",
                                                    style: theme
                                                        .textTheme.headlineSmall
                                                        ?.copyWith(fontSize: 14),
                                                    children: [
                                                      TextSpan(
                                                          text: relevantSessions[
                                                                  index]
                                                              .timeString,
                                                          style: const TextStyle(
                                                              color:
                                                                  primaryColor))
                                                    ]),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                    child: Column(
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => LogsScreen(
                                                    session:
                                                        relevantSessions[index]),
                                              ));
                                        },
                                        child: const Text('View Logs')),
                                    relevantSessions[index].media != null
                                        ? TextButton(
                                            onPressed: () {
                                              launchUrl(Uri.parse(
                                                  relevantSessions[index]
                                                      .media!));
                                            },
                                            child: const Text('Recording'))
                                        : const SizedBox.shrink()
                                  ],
                                ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

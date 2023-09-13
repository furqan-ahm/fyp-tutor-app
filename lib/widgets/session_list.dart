import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_app/providers/session_provider.dart';
import 'package:tutor_app/screens/tutor/session_screen.dart';

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
                                ? ' will appear here a meeting is scheduled.'
                                : ' will appear here a meeting is scheduled.',
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
                          widget.isStudent
                              ? const SizedBox.shrink()
                              : MenuAnchor(
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
                                        onPressed: () {},
                                        child: const Text('Postpone'),
                                      ),
                                      MenuItemButton(
                                        onPressed: () {},
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
                          relevantSessions[index].isLive
                              ? FloatingActionButton.extended(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SessionScreen(
                                              session: relevantSessions[index]),
                                        ));
                                  },
                                  label: const Text(' Join '),
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

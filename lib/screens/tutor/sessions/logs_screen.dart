import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:tutor_app/constants/colors.dart';
import 'package:tutor_app/models/session_model.dart';
import 'package:tutor_app/repository/firebase_firestore_repo.dart';
import 'package:tutor_app/theme.dart';
import 'package:tutor_app/widgets/common/max_sized_container.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({Key? key, required this.session}) : super(key: key);

  final Session session;

  @override
  _LogsScreenState createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  List<Map> meetingLogs = [];
  @override
  void initState() {
    super.initState();
    FirestoreRepository.getMeetingLogs(widget.session.id).then((value) {
      setState(() {
        meetingLogs = value;
        loading = false;
      });
    });
  }

  bool loading = true;

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
                  child: Text('Session Logs',
                      style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold, fontSize: 19)),
                ),
                const SizedBox(
                  height: 10,
                ),
                loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : meetingLogs.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(horizontal: 18),
                            primary: false,
                            itemCount: meetingLogs.length,
                            itemBuilder: (context, index) {
                              var log = meetingLogs[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  color: baseColor,
                                  child: Row(
                                    children: [
                                      Expanded(child: Text(log['log'])),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        (log['time'] as Timestamp)
                                            .toDate()
                                            .format('M j, H:i'),
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                                'No logs recorded for this session. It might mean that it wasnt held'),
                          )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

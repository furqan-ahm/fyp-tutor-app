/*

Chat System, credits to Furqan (furqan-ahm) 
https://github.com/furqan-ahm

*/

import 'package:flutter/material.dart';
import 'package:tutor_app/providers/auth_provider.dart';
import 'package:tutor_app/repository/firebase_firestore_repo.dart';
import 'package:tutor_app/widgets/common/custom_appbar.dart';

import '../../../models/chat_room_model.dart';
import '../../../models/message_model.dart';
import '../../../models/user_model.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
    required this.chatRoom,
    required this.otherUser,
  }) : super(key: key);

  static const String routeName = '/chat-screen';
  final ChatRoom chatRoom;
  final AppUser otherUser;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  bool loading = true;
  AppUser? _currentUser;

  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentUser=AuthProvider.of(context).currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(title: widget.otherUser.name,canPop: true,),
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream:
                  FirestoreRepository.getMessages(widget.chatRoom.chatRoomId!),
              builder: (context, snapshot) {
                List<Message> messages = snapshot.hasData ? snapshot.data! : [];

                if (messages.isNotEmpty) {
                  FirestoreRepository.markMessagesRead(
                    widget.chatRoom.chatRoomId!,
                    widget.otherUser.uid,
                    messages.first,
                  );
                }

                return ListView.builder(
                  itemCount: messages.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    bool isSentByMe =
                        messages[index].sender!.uid == _currentUser!.uid;
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      margin: const EdgeInsets.only(bottom: 8),
                      alignment: isSentByMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(20),
                            topRight: const Radius.circular(20),
                            bottomLeft: Radius.circular(isSentByMe ? 20 : 0),
                            bottomRight: Radius.circular(isSentByMe ? 0 : 20),
                          ),
                          color: isSentByMe
                              ? Theme.of(context).primaryColor.withOpacity(0.75)
                              : Colors.blueGrey,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              messages[index].text!,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  messages[index].time!.hour.toString() +
                                      ':' +
                                      messages[index].time!.minute.toString(),
                                  style: const TextStyle(color: Colors.black),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                isSentByMe
                                    ? Icon(
                                        messages[index].unread!
                                            ? Icons.check_circle_outline
                                            : Icons.check_circle,
                                        size: 18,
                                      )
                                    : Container()
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    maxLines: null,
                    controller: messageController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    FirestoreRepository.uploadMessage(
                      widget.chatRoom.chatRoomId!,
                      Message(
                        text: messageController.text,
                        unread: true,
                        sender: _currentUser,
                        reciever: widget.otherUser,
                        time: DateTime.now(),
                      ),
                    );
                    messageController.clear();
                  },
                  icon: const Icon(
                    Icons.send,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:tutor_app/models/chat_room_model.dart';
import 'package:tutor_app/models/user_model.dart';
import 'package:tutor_app/providers/auth_provider.dart';
import 'package:tutor_app/repository/firebase_firestore_repo.dart';

import '../../../constants/colors.dart';
import '../../../widgets/common/custom_appbar.dart';
import '../../../widgets/inbox/chat_tile.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({Key? key}) : super(key: key);

  @override
  _InboxScreenState createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const CustomAppBar(
            title: 'Inbox',
            backgroundColor: Colors.transparent,
            canPop: false,
            centerTitle: true,
          ),
          
          StreamBuilder<List<ChatRoom>>(
            stream: FirestoreRepository.getChatRooms(AuthProvider.of(context).currentUser.uid),
            builder: (context, snapshot) {
              
              if(snapshot.connectionState==ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator(),);
              }
              if(snapshot.data==null||snapshot.data!.isEmpty){
                return Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(children: [
                  Text(
                    "You dont have any messages at the moment",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(
                            color: bodyTextColor.withOpacity(0.5)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  
                ]),
              );
              }

              List<ChatRoom> rooms=snapshot.data!;
              return Expanded(
                      child: ListView.builder(
                        itemCount: rooms.length,
                        itemBuilder: (context, index) => ChatTile(
                            room: rooms[index]
                        ),
                      ),
                    );
            }
          )
        ],
      ),
    );
  }
}

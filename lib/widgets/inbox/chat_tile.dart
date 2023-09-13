import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tutor_app/models/user_model.dart';
import 'package:tutor_app/providers/auth_provider.dart';

import '../../constants/colors.dart';
import '../../models/chat_room_model.dart';
import '../../models/message_model.dart';
import '../../screens/tutor/inbox/chat_screen.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({Key? key, required this.room}) : super(key: key);

  final ChatRoom room;

  @override
  Widget build(BuildContext context) {
    AppUser currentUser = AuthProvider.of(context).currentUser;

    Message lastMessage = room.lastMessage!;

    bool isSentByMe = lastMessage.sender!.uid == currentUser!.uid;

    AppUser targetUser =
        isSentByMe ? lastMessage.reciever! : lastMessage.sender!;

    bool seen = !(lastMessage.unread!);

    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                chatRoom: room,
                otherUser: targetUser,
              ),
            ));
      },
      leading: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                color: isSentByMe||seen ? Colors.transparent : accentColor, width: 2)),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: primaryColor),
          child: const Icon(
            IconsaxOutline.user,
            color: Colors.white,
          ),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            targetUser.name,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontSize: 15),
          ),
          Text(
            '${lastMessage.time!.hour}:${lastMessage.time!.minute}', 
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      subtitle: Text(
        lastMessage.text!, //(room.lastMessage!.isSentByUser?"You: ":"")+room.lastMessage!.text,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
            fontWeight: isSentByMe||seen ? null : FontWeight.bold,
            color: isSentByMe||seen ? Colors.black : null),
      ),
    );
  }
}

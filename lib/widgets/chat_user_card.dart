import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api/apis.dart';
import '../helper/my_date_util.dart';
import '../main.dart';
import '../models/chat_user.dart';
import '../models/message.dart';
import 'dialogs/profile_dialog.dart';

//card to represent a single user in home screen
class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  final Function() onChatTap;

  const ChatUserCard({super.key, required this.user, required this.onChatTap});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  //last message info (if null --> no message)
  Message? _message;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: widget.onChatTap,
        // onTap: () {
        //   Get.to(ChatScreen(user: widget.user));
        // },
        child: StreamBuilder(
          stream: APIs.getLastMessage(widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list =
                data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
            if (list.isNotEmpty) _message = list[0];
            return FutureBuilder(
                future: APIs.getUnreadMessageCount(widget.user),
                builder: (context, mesCount) {
                  return ListTile(
                    //user profile picture
                    leading: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (_) => ProfileDialog(user: widget.user));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(mq.height * .03),
                        child: CachedNetworkImage(
                          width: mq.height * .055,
                          height: mq.height * .055,
                          imageUrl: widget.user.image,
                          errorWidget: (context, url, error) =>
                              const CircleAvatar(
                                  child: Icon(CupertinoIcons.person)),
                        ),
                      ),
                    ),
                    //user name
                    title: Text(widget.user.name),
                    //last message
                    subtitle: Text(
                        _message != null
                            ? _message!.type == Type.image
                                ? 'image'
                                : _message!.msg
                            : widget.user.about,
                        maxLines: 1),

                    //last message time
                    trailing: _message == null
                        ? null //show nothing when no message is sent
                        : _message!.read.isEmpty &&
                                _message!.fromId != APIs.user.uid &&
                                mesCount.data != 0
                            ?
                            //show for unread message
                            Container(
                                decoration: BoxDecoration(
                                    color: Colors.greenAccent.shade400,
                                    borderRadius: BorderRadius.circular(5000)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: mesCount.data != null
                                      ? Text(mesCount.data,
                                          textAlign: TextAlign.center)
                                      : const Text(""),
                                ),
                              )
                            :
                            //message sent time
                            Text(
                                MyDateUtil.getLastMessageTime(
                                    context: context, time: _message!.sent),
                                style: const TextStyle(color: Colors.black54),
                              ),
                  );
                });
          },
        ));
  }
}

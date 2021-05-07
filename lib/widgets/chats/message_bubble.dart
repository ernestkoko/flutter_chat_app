import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String? message;
  final bool? isMe;
  final String? image;
  final Key? key;

  final String? username;

  const MessageBubble(
      {this.message, this.isMe, this.key, this.username, this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isMe! ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: isMe! ? Colors.grey[300] : Theme.of(context).accentColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: !isMe! ? Radius.circular(0) : Radius.circular(12),
                bottomRight: isMe! ? Radius.circular(0) : Radius.circular(12),
              ),
            ),
            // width: MediaQuery.of(context).size.width * 0.85,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Column(
              crossAxisAlignment:
                  isMe! ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Text(
                      username!,
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          color: isMe!
                              ? Colors.black
                              : Theme.of(context)
                                  .accentTextTheme
                                  .headline1!
                                  .color),
                    ),
                    Positioned(
                        top: -30,
                        right: !isMe! ? -40 : null,
                        left: !isMe! ? null : -40,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(image!),
                        ))
                  ],
                ),
                Text(
                  message ?? 'Former',
                  style: TextStyle(
                      color: isMe!
                          ? Colors.black
                          : Theme.of(context).accentTextTheme.headline1!.color),
                  textAlign: isMe! ? TextAlign.end : TextAlign.start,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

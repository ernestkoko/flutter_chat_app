import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/widgets/chats/message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
        future: Future.value(FirebaseAuth.instance.currentUser),
        builder: (ctx, futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chat')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                final chatDocs = snapshot.data!.docs;

                return ListView.builder(
                    reverse: true,
                    itemCount: chatDocs.length,
                    itemBuilder: (ctx, int index) => Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: MessageBubble(
                            message: chatDocs[index]['text'],
                            username: chatDocs[index]['username'],
                            image: chatDocs[index]['userImage'],
                            isMe: chatDocs[index]['userId'] ==
                                futureSnapshot.data!.uid,
                            key: ValueKey(chatDocs[index].id),
                          ),
                    ));
              });
        });
  }
}

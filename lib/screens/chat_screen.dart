import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/widgets/chats/messages.dart';
import 'package:flutter_chat_app/widgets/chats/new_message.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        actions: [
          DropdownButton(
            icon: Icon(
              Icons.more_vert_rounded,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: [Icon(Icons.exit_to_app), Text('Logout')],
                  ),
                ),
                value: "logout",
              )
            ],
            onChanged: (itemIdentifier) async {
              if (itemIdentifier == 'logout') {
                await FirebaseAuth.instance.signOut();
              }
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Messages(),
            ),
            NewMessage(),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () {
      //     FirebaseFirestore.instance
      //         .collection("chats/qmFnTS8qW9gWx2BW3b2S/messages")
      //         .add({'text': 'This was added by clicking the button'});
      //   },
      // ),
    );
  }
}

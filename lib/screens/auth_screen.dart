import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(String? email, String? password, String? userName,
      bool isLogIn, File image) async {
    UserCredential credential;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogIn) {
        ///sign in the user

        credential = await _auth.signInWithEmailAndPassword(
            email: email!, password: password!);
      } else {
        ///log in the user
        credential = await _auth.createUserWithEmailAndPassword(
            email: email!, password: password!);

        ///... perform the image upload first so the path to the image can be stored
        ///on firestore also
        final reference = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child(credential.user!.uid + ".jpg");

        await reference.putFile(image).whenComplete(() {});

        ///get the download url
        final imageUrl = await reference.getDownloadURL();

        ///store the user name if the signing up is successful
        await FirebaseFirestore.instance
            .collection('users')
            .doc(credential.user!.uid)
            .set({'username': userName, 'email': email, 'image_url': imageUrl});
      }
      setState(() {
        _isLoading = false;
      });
    } on FirebaseAuthException catch (error) {
      var messages = "An error occurred, please check your credentials";

      if (error.message != null) {
        messages = error.message!;
      }

      ///show a snackBar
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(messages)));
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print("General error: $error");

      ///show a snackBar
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: AuthForm(_submitAuthForm, _isLoading));
  }
}

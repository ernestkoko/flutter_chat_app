import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/widgets/pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.isLoading);

  final bool isLoading;
  final void Function(
          String? email, String? passord, String? userName, bool isLogedin, File userImage)
      submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLoggedIn = true;
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  File? _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _submit() {
    final isValid = _formKey.currentState!.validate();

    ///hide the soft keyboard
    FocusScope.of(context).unfocus();

    ///stop execution if the image file is null
    if (_userImageFile == null && !_isLoggedIn) {
      ///show a snack bar after removing the current snackbar if any
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please ensure you pick and image'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    ///check if all the forms are valid
    if (isValid) {
      ///trigger the onSaved callback of the Text form fields
      _formKey.currentState!.save();

      widget.submitFn(_userEmail.trim(), _userPassword.trim(), _userName.trim(),
          _isLoggedIn, _userImageFile!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (!_isLoggedIn) UserImagePicker(_pickedImage),
                    TextFormField(
                      key: ValueKey('email'),
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return "Please enter a valid email address";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userEmail = value!;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(labelText: 'Email address'),
                    ),
                    if (!_isLoggedIn)
                      TextFormField(
                        key: ValueKey('username'),
                        validator: (value) {
                          if (value!.length < 4 || value.isEmpty) {
                            return 'Enter at least 4 characters.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _userName = value!;
                        },
                        decoration: InputDecoration(labelText: 'Username'),
                      ),
                    TextFormField(
                      key: ValueKey('password'),
                      validator: (value) {
                        if (value!.length < 7 || value.isEmpty) {
                          return 'Password must be at least 7 characters long.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userPassword = value!;
                      },
                      onChanged: (value) {},
                      obscureText: true,
                      decoration: InputDecoration(labelText: "Password"),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    widget.isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _submit,
                            child: Text(_isLoggedIn ? 'Login' : 'Sign up')),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            _isLoggedIn = !_isLoggedIn;
                          });
                        },
                        child: Text(_isLoggedIn
                            ? 'Create an account'
                            : 'I already have an account'))
                  ],
                )),
          ),
        ),
      ),
    );
  }
}

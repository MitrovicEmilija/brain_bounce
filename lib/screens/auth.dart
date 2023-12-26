import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

import 'package:brain_bounce/widgets/user_image_picker.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  var _isLogin = true;
  var _enteredEmail = '';
  var _enteredPassword = '';
  File? _selectedImage;
  var _isAuthenticating = false;
  var _enteredUsername = '';

  void _submit() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid || !_isLogin && _selectedImage == null) {
      return;
    }

    _formKey.currentState!.save();

    try {
      setState(() {
        _isAuthenticating = true;
      });
      if (_isLogin) {
        final userCredentials = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredentials.user!.uid}.jpg');

        await storageRef.putFile(_selectedImage!);
        final imageUrl = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set({
          'username': _enteredUsername,
          'email': _enteredEmail,
          'image_url': imageUrl,
        });
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        // ...
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed.'),
          // ignore: use_build_context_synchronously
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(255, 243, 233, 1),
        body: Stack(
          children: [
            Positioned.fill(
                child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            )),
            Center(
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Text(
                          'WELCOME TO BRAIN BOUNCE',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'JosefinSans',
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(87, 51, 83, 1)),
                        ),
                      ),
                      Card(
                        color: const Color.fromRGBO(255, 243, 233, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        margin: _isLogin
                            ? const EdgeInsets.only(
                                top: 200, right: 20, left: 20, bottom: 10)
                            : const EdgeInsets.only(
                                top: 100, right: 20, left: 20, bottom: 10),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (!_isLogin)
                                      UserImagePicker(
                                        onPickImage: (pickedImage) {
                                          _selectedImage = pickedImage;
                                        },
                                      ),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                          labelText: 'Email Address',
                                          labelStyle: TextStyle(
                                              fontFamily: 'JosefinSans',
                                              color: Color.fromRGBO(
                                                  87, 51, 83, 1))),
                                      keyboardType: TextInputType.emailAddress,
                                      autocorrect: false,
                                      textCapitalization:
                                          TextCapitalization.none,
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty ||
                                            !value.contains('@')) {
                                          return 'Please enter a valid email address.';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _enteredEmail = value!;
                                      },
                                    ),
                                    if (!_isLogin)
                                      TextFormField(
                                          decoration: const InputDecoration(
                                              labelText: 'Username',
                                              labelStyle: TextStyle(
                                                  fontFamily: 'JosefinSans',
                                                  color: Color.fromRGBO(
                                                      87, 51, 83, 1))),
                                          enableSuggestions: false,
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty ||
                                                value.trim().length < 4) {
                                              return 'Username must be at least 4 characters long.';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            _enteredUsername = value!;
                                          }),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                          labelText: 'Password',
                                          labelStyle: TextStyle(
                                              fontFamily: 'JosefinSans',
                                              color: Color.fromRGBO(
                                                  87, 51, 83, 1))),
                                      obscureText: true,
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty ||
                                            value.trim().length < 6) {
                                          return 'Password must be at least 6 characters long.';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _enteredPassword = value!;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    if (_isAuthenticating)
                                      const CircularProgressIndicator(),
                                    if (!_isAuthenticating)
                                      ElevatedButton(
                                          onPressed: _submit,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    253, 167, 88, 1),
                                          ),
                                          child: Text(
                                            _isLogin ? 'Login' : 'Signup',
                                            style: const TextStyle(
                                                fontFamily: 'JosefinSans',
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromRGBO(
                                                    87, 51, 83, 1)),
                                          )),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    if (!_isAuthenticating)
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _isLogin = !_isLogin;
                                          });
                                        },
                                        child: Text(
                                          _isLogin
                                              ? 'Create an account'
                                              : 'I already have an account',
                                          style: const TextStyle(
                                              fontFamily: 'JosefinSans',
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromRGBO(
                                                  87, 51, 83, 1)),
                                        ),
                                      ),
                                  ]),
                            ),
                          ),
                        ),
                      )
                    ]),
              ),
            ),
          ],
        ));
  }
}

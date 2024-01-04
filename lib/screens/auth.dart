import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

import 'package:brain_bounce/widgets/user_image_picker.dart';
import 'package:brain_bounce/screens/profile.dart';
import 'package:brain_bounce/screens/categories.dart';

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
        // ignore: unused_local_variable
        final userCredentials = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);

        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Profile(),
          ),
        );
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

        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Categories()),
        );
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        // ...
      }
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).clearSnackBars();
      // ignore: use_build_context_synchronously
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
              'assets/images/background-new.png',
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
            )),
            Align(
              alignment: const Alignment(0, -0.07),
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 0.0),
                        child: Text(
                          'WELCOME TO BRAIN \nBOUNCE',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'JosefinSans',
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              color: Color.fromRGBO(87, 51, 83, 1)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22.0),
                        child: ElevatedButton.icon(
                          icon: Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Image.asset(
                              'assets/images/google-icon.png',
                              height: 35.0,
                            ),
                          ),
                          label: const Padding(
                            padding: EdgeInsets.only(left: 10.0, right: 40.0),
                            child: DefaultTextStyle(
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Manrope',
                                  color: Color.fromRGBO(87, 51, 83, 1)),
                              child: Text('Continue with Google'),
                            ),
                          ),
                          onPressed: () {
                            // We dont do anything here :) This is just to show
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minimumSize: const Size(double.infinity, 45),
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
            Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: MediaQuery.of(context).size.height * 0.40,
                child: Card(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0),
                    ),
                  ),
                  margin: _isLogin
                      ? const EdgeInsets.only(
                          top: 0, right: 0, left: 00, bottom: 00)
                      : const EdgeInsets.only(
                          top: 0, right: 00, left: 00, bottom: 00),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Form(
                        key: _formKey,
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          if (!_isLogin)
                            UserImagePicker(
                              onPickImage: (pickedImage) {
                                _selectedImage = pickedImage;
                              },
                            ),
                          const Center(
                            child: Text(
                              'Log in with email',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15.5,
                                  fontFamily: 'Manrope'),
                            ),
                          ),
                          const Divider(
                            color: Colors.grey,
                            thickness: 0,
                            height: 25,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(
                                  color: Color.fromRGBO(87, 51, 83, 1),
                                  fontFamily: 'Manrope'),
                              prefixIcon: IconTheme(
                                data: IconThemeData(
                                  size: 17.0, // Smaller icon size
                                  color: Color.fromRGBO(253, 167, 88, 1),
                                ),
                                child: Icon(
                                  Icons.email,
                                ),
                              ),
                              filled: true,
                              fillColor: Color(0xFFFFF3E9),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 0), // Transparent border
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15.0),
                                  topRight: Radius.circular(15.0),
                                  bottomLeft: Radius.circular(15.0),
                                  bottomRight: Radius.circular(15.0),
                                ), // Rounded corners on the top
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 0),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15.0),
                                  topRight: Radius.circular(15.0),
                                  bottomLeft: Radius.circular(15.0),
                                  bottomRight: Radius.circular(15.0),
                                ),
                              ),
                            ),
                            style: const TextStyle(
                                color: Color(0xFFFDA758),
                                decoration: TextDecoration.none,
                                fontFamily: 'Manrope'),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
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
                          const SizedBox(
                            height: 6,
                          ),
                          if (!_isLogin)
                            TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Username',
                                  labelStyle: TextStyle(
                                      fontFamily: 'Manrope',
                                      color: Color.fromRGBO(87, 51, 83, 1)),
                                  prefixIcon: IconTheme(
                                    data: IconThemeData(
                                      size: 17.0, // Smaller icon size
                                      color: Color.fromRGBO(253, 167, 88, 1),
                                    ),
                                    child: Icon(
                                      Icons.supervised_user_circle_outlined,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Color(0xFFFFF3E9),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 0), // Transparent border
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15.0),
                                      topRight: Radius.circular(15.0),
                                      bottomLeft: Radius.circular(15.0),
                                      bottomRight: Radius.circular(15.0),
                                    ), // Rounded corners on the top
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.transparent, width: 0),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15.0),
                                      topRight: Radius.circular(15.0),
                                      bottomLeft: Radius.circular(15.0),
                                      bottomRight: Radius.circular(15.0),
                                    ),
                                  ),
                                ),
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
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: const TextStyle(
                                    color: Color.fromRGBO(87, 51, 83, 1),
                                    fontFamily: 'Manrope'),
                                prefixIcon: const IconTheme(
                                  data: IconThemeData(
                                    size: 17.0,
                                    color: Color(0xFFFDA758),
                                  ),
                                  child: Icon(
                                    Icons.lock,
                                    color: Color(0xFFFDA758),
                                  ),
                                ),
                                filled: true,
                                fillColor: const Color(0xFFFFF3E9),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.transparent, width: 0),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.transparent, width: 0),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                              style: const TextStyle(
                                color: Color(0xFFFDA758),
                                decoration: TextDecoration.none,
                              ),
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
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          if (_isAuthenticating)
                            const CircularProgressIndicator(),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                onPressed: _submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromRGBO(253, 167, 88, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(9.0),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0, horizontal: 32.0),
                                  minimumSize: const Size(double.infinity, 50),
                                ),
                                child: Text(
                                  _isLogin ? 'Login' : 'Signup',
                                  style: const TextStyle(
                                    fontFamily: 'Manrope',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(87, 51, 83, 1),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 25),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: _isLogin
                                        ? Padding(
                                            padding: EdgeInsets.zero,
                                            child: TextButton(
                                              onPressed: () {
                                                // TODO: Implement forgot password functionality
                                              },
                                              style: ButtonStyle(
                                                padding:
                                                    MaterialStateProperty.all(
                                                        EdgeInsets.zero),
                                                tapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                                minimumSize:
                                                    MaterialStateProperty.all(
                                                        Size.zero),
                                              ),
                                              child: const Text(
                                                'Forgot Password?',
                                                style: TextStyle(
                                                  fontFamily: 'Manrope',
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromRGBO(
                                                      87, 51, 83, 1),
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                            ),
                                          )
                                        : const SizedBox
                                            .shrink(), // This will show nothing if _isLogin is false
                                  ),
                                  Padding(
                                    padding: EdgeInsets.zero,
                                    child: Center(
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _isLogin = !_isLogin;
                                          });
                                        },
                                        style: ButtonStyle(
                                          padding: MaterialStateProperty.all(
                                              EdgeInsets.zero),
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          minimumSize:
                                              MaterialStateProperty.all(
                                                  Size.zero),
                                        ),
                                        child: RichText(
                                          text: TextSpan(
                                            style: const TextStyle(
                                              fontFamily: 'JosefinSans',
                                              color:
                                                  Color.fromRGBO(87, 51, 83, 1),
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: _isLogin
                                                      ? "Don't have an account? "
                                                      : 'Already have an account? ',
                                                  style: const TextStyle(
                                                      fontFamily: 'Manrope')),
                                              TextSpan(
                                                text: _isLogin
                                                    ? 'Sign up'
                                                    : 'Login',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Manrope'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        ]),
                      ),
                    ),
                  ),
                ))
          ],
        ));
  }
}

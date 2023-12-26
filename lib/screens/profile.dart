import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? username;
  String? profileImageUrl;

  Future<DocumentSnapshot> getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    return userData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(255, 243, 233, 1),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(255, 243, 233, 1),
          iconTheme: const IconThemeData(
            color: Color.fromRGBO(87, 51, 83, 1),
            size: 30.0,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              color: const Color.fromRGBO(87, 51, 83, 1),
              onPressed: () {},
            )
          ],
          title: const Text(
            'Profile',
            style: TextStyle(
                fontFamily: 'JosefinSans',
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Color.fromRGBO(87, 51, 83, 1)),
          ),
        ),
        body: FutureBuilder<DocumentSnapshot>(
          future: getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Something went wrong: ${snapshot.error}');
            } else {
              username = snapshot.data!['username'];
              profileImageUrl = snapshot.data!['image_url'];

              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(profileImageUrl!),
                        backgroundColor: Colors.transparent,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        username!,
                        style: const TextStyle(
                            fontFamily: 'JosefinSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color.fromRGBO(87, 51, 83, 1)),
                      ),
                    ]),
              );
            }
          },
        ));
  }
}

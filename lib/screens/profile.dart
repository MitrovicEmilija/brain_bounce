import 'package:brain_bounce/screens/communities.dart';

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
  String? email;
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
            email = snapshot.data!['email'];
            profileImageUrl = snapshot.data!['image_url'];

            return Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(profileImageUrl!),
                              backgroundColor: Colors.transparent,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Username: $username',
                                  style: const TextStyle(
                                      fontFamily: 'JosefinSans',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Color.fromRGBO(87, 51, 83, 1)),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Email: $email',
                                  style: const TextStyle(
                                      fontFamily: 'JosefinSans',
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15,
                                      color: Color.fromRGBO(87, 51, 83, 1)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        //
                      },
                      child: const SizedBox(
                        height: 60,
                        width: double.infinity,
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Row(
                              children: [
                                Image(
                                  image: AssetImage(
                                    'assets/images/community-icon.png',
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'My community',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'JosefinSans',
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromRGBO(87, 51, 83, 1),
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        //
                      },
                      child: const SizedBox(
                        height: 80,
                        width: double.infinity,
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.notifications,
                                  size: 30,
                                  color: Color.fromRGBO(252, 157, 69, 1),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Notifications',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontFamily: 'JosefinSans',
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromRGBO(87, 51, 83, 1),
                                          fontSize: 16),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Customize notifications',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontFamily: 'JosefinSans',
                                          fontWeight: FontWeight.normal,
                                          color:
                                              Color.fromRGBO(121, 118, 120, 1),
                                          fontSize: 14),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        //
                      },
                      child: const SizedBox(
                        height: 80,
                        width: double.infinity,
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.more_horiz_outlined,
                                  size: 30,
                                  color: Color.fromRGBO(252, 157, 69, 1),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'More customization',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontFamily: 'JosefinSans',
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromRGBO(87, 51, 83, 1),
                                          fontSize: 16),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Customize it more to fit your usage',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontFamily: 'JosefinSans',
                                          fontWeight: FontWeight.normal,
                                          color:
                                              Color.fromRGBO(121, 118, 120, 1),
                                          fontSize: 14),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ]),
            );
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
            height: 60,
            child: Row(
              children: [
                const SizedBox(
                  width: 60,
                ),
                IconButton(
                    iconSize: 50,
                    onPressed: () {
                      //
                    },
                    icon: const Image(
                        image: AssetImage('assets/images/home-icon.png'))),
                const SizedBox(
                  width: 40,
                ),
                IconButton(
                    iconSize: 50,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const Communities()));
                    },
                    icon: const Image(
                        image: AssetImage('assets/images/community-icon.png'))),
                const SizedBox(
                  width: 40,
                ),
                IconButton(
                    iconSize: 50,
                    onPressed: () {
                      //
                    },
                    icon: const Image(
                        image: AssetImage('assets/images/settings-icon.png'))),
              ],
            )),
      ),
    );
  }
}

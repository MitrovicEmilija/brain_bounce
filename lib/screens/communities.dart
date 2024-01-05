import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:brain_bounce/models/community.dart';

class Communities extends StatefulWidget {
  const Communities({super.key});

  @override
  State<Communities> createState() {
    return _CommunitiesState();
  }
}

class _CommunitiesState extends State<Communities> {
  late List<Community> communities = [];

  @override
  void initState() {
    super.initState();
    fetchCommunities();
  }

  Future<void> fetchCommunities() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.14:9090/api/communities'));

    if (response.statusCode == 200) {
      final List<dynamic> communityData = json.decode(response.body);
      // ignore: avoid_print
      print('Received data from the backend: $communityData');

      setState(() {
        communities = communityData.map((community) {
          return Community(
              name: community['name'], description: community['description']);
        }).toList();
      });
      // ignore: avoid_print
      print('Communities loaded successfully: $communities');
    } else {
      // ignore: avoid_print
      print('Failed to load communities');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(255, 243, 233, 1),
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(255, 243, 233, 1),
          iconTheme: const IconThemeData(color: Color.fromRGBO(87, 51, 83, 1)),
          actions: [
            IconButton(
              onPressed: () {
                //
              },
              icon: const Icon(Icons.add_circle),
              iconSize: 35,
            ),
          ],
          title: const Text(
            'Communities',
            style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(87, 51, 83, 1)),
          ),
        ),
        body: communities.isNotEmpty
            ? ListView.builder(
                itemCount: communities.length,
                itemBuilder: (context, index) {
                  final community = communities[index];
                  return ListTile(
                    title: Text(community.name,
                        style: const TextStyle(
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(87, 51, 83, 1))),
                    subtitle: Text(
                      community.description,
                      style: const TextStyle(
                          fontFamily: 'Manrope', fontWeight: FontWeight.w500),
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // they should be able to join with invite code
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                        backgroundColor: const Color.fromRGBO(253, 167, 88, 1),
                      ),
                      child: const Text(
                        'Join',
                        style: TextStyle(
                          fontFamily: 'JosefinSans',
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(87, 51, 83, 1),
                        ),
                      ),
                    ),
                  );
                },
              )
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }
}

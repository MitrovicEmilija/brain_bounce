import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:brain_bounce/screens/profile.dart';
import 'package:brain_bounce/models/category.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  late List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 243, 233, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 243, 233, 1),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            color: const Color.fromRGBO(87, 51, 83, 1),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          )
        ],
        title: const Text(
          'Categories',
          style: TextStyle(
              fontFamily: 'JosefinSans',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color.fromRGBO(87, 51, 83, 1)),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Card(
                  child: Center(
                    child: Text(
                      'Category $index',
                      style: const TextStyle(
                        fontFamily: 'JosefinSans',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color.fromRGBO(87, 51, 83, 1),
                      ),
                    ),
                  ),
                );
              },
              childCount: 6,
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Profile(),
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(253, 167, 88, 1),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontFamily: 'JosefinSans',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(87, 51, 83, 1),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:brain_bounce/screens/auth.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 243, 233, 1),
      body: Center(
        child: SingleChildScrollView(
            child: Column(
          children: [
            const Text(
              'WELCOME TO BRAIN BOUNCE',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'JosefinSans',
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(87, 51, 83, 1)),
            ),
            Image.asset('assets/images/welcome.png'),
            Container(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: const Text(
                'WE CAN HELP YOU TO BE A BETTER VERSION OF YOURSELF',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'JosefinSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(87, 51, 83, 1)),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AuthScreen(),
                ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(253, 167, 88, 1),
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(
                    fontFamily: 'JosefinSans',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(87, 51, 83, 1)),
              ),
            )
          ],
        )),
      ),
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pashudhan/Authentication/Authentication.dart';
import 'package:pashudhan/pages/Homepage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:tailorapptask/services/supabase_stuff.dart';
import 'package:pashudhan/pages/intro.dart';
import 'package:google_fonts/google_fonts.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://media0.giphy.com/media/v1.Y2lkPWVjZjA1ZTQ3ZWN3dnhlenFsbjU5dW41bjEzN2w2ZTUyaHE2YXZkbXJzaWo0bmdsdyZlcD12MV9naWZzX3NlYXJjaCZjdD1n/ITRemFlr5tS39AzQUL/giphy.webp',
            fit: BoxFit.cover,
          ),
      Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 60),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              minimumSize: const Size(280, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: Icon(Icons.login, color: Colors.grey[700]),
            label: const Text(
              'Proceed to Login',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
          ),
        ),
      )

      ],

      ),
    );
    // return const Placeholder();
  }
}

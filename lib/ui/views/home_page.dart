import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser;


  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
              onPressed: signOut,
              icon: const Icon(
                Icons.logout_rounded,
              )),
        ],
      ),
      body:  Center(
        child: Text('Welcome to the Home Page ${user!.email!}' ),
      ),
    );
  }
}

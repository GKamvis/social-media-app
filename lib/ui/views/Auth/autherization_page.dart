import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/ui/views/Auth/login_page.dart';

import '../Home_page_text_based/home_page_text_based.dart';

class AutherizationPage extends StatelessWidget {
  const AutherizationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return   HomePage();
          } else {
            return  const LoginPage();
          }
        },
      ),
    );
  }
}
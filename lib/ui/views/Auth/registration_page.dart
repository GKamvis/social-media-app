import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final TextEditingController _fullNameController = TextEditingController();

  final TextEditingController _ageController = TextEditingController();

  bool tfColor = false;
  bool tfColorPassword = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future signUp() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _confirmPasswordController.text.trim() ==
                _passwordController.text.trim()
            ? _passwordController.text.trim()
            : '',
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        weaKPassword();
        setState(() {
          tfColorPassword = true;
        });
      } else if (e.code == 'email-already-in-use') {
        usedEmail();
        setState(() {
          tfColor = true;
        });
      } else {
        wrongEmailOrPassword();
      }
    }
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim());
    Navigator.pushNamed(context, '/auth');

    // add user details
    addUserDetails(
      _fullNameController.text.trim(),
      int.parse(_ageController.text.trim()),
      _emailController.text.trim(),
    );
  }

  Future addUserDetails(String fullName, int age, String email) async {
    FirebaseFirestore.instance.collection('users').add({
      'full name': fullName,
      'age': age,
      'email': email,
    });
  }

  void wrongEmailOrPassword() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Invalid format for email or password'),
        );
      },
    );
  }

  void weaKPassword() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Invalid format for email or password'),
        );
      },
    );
  }

  void usedEmail() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('email already used'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Page'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: tfColor ? Colors.red : Colors.amber, width: 4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: tfColor ? Colors.red : Colors.amber, width: 4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red, width: 4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const Gap(20),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: tfColorPassword ? Colors.red : Colors.amber,
                        width: 4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: tfColor ? Colors.red : Colors.amber, width: 4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red, width: 4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const Gap(20),
              TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  hintText: 'Confrim Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: tfColorPassword ? Colors.red : Colors.amber,
                        width: 4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: tfColor ? Colors.red : Colors.amber, width: 4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red, width: 4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const Gap(20),
                TextField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  hintText: 'Fulll Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.amber,
                        width: 4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color:  Colors.amber, width: 4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                 
                  
                ),
              ),
              const Gap(20),
               TextField(
                controller: _ageController,
                decoration: InputDecoration(
                  hintText: 'Age',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.amber,
                        width: 4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color:  Colors.amber, width: 4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                 
                  
                ),
              ),
              const Gap(20),
              MaterialButton(
                onPressed: signUp,
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Text('I\'m already a member',
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text(
                      'Log In Now',
                      style: TextStyle(color: Colors.amber),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

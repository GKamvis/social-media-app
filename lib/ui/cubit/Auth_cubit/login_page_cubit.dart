import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPageCubit extends Cubit<void>{
  LoginPageCubit() : super(0);

  bool tfColor = false;

   void signIn( String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
          tfColor = true;
      } else if (e.code == 'wrong-password') {
          tfColor = true;
      } else {
          tfColor = true;
      }
    }
  }

  
}

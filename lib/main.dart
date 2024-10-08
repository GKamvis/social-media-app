import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/ui/cubit/Auth_cubit/login_page_cubit.dart';
import 'package:myapp/ui/views/Auth/login_page.dart';
import 'package:myapp/ui/views/Auth/registration_page.dart';

import 'ui/cubit/Auth_cubit/home_page_cubit.dart';
import 'ui/views/Auth/autherization_page.dart';
import 'ui/views/Auth/forgot_password_page.dart';
import 'ui/views/Home_page_text_based/home_page_text_based.dart';
import 'ui/views/Image_share_page/image_post.dart';

void main()  async{
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: kIsWeb || Platform.isAndroid ? const FirebaseOptions(
      apiKey: "AIzaSyBq-cJgIS-iJl5M-ixJ0MsbjPhkgrA2nU8",
      appId: "1:901694373966:android:a6f7a93ba205a3d949031f", 
      messagingSenderId: "901694373966", 
      projectId:  "mini-social-c7847",
    )
    : null,
  );
  runApp(const MyApp());
} 

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoginPageCubit()),
        BlocProvider(create: (_) => HomePageCubit()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const AutherizationPage(),
        routes: {
          '/home': (context) =>  HomePage(),
          '/login': (context) =>   const LoginPage(), 
          '/register': (context) =>   const RegistrationPage(),
          '/forgot': (context) =>  const ForgotPasswordPage(),
          '/auth' :(context) => const AutherizationPage(),
          '/image_share': (context) => const ImagePost(),
        },
      ),
    );
  }
}
      

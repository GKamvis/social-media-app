import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/ui/cubit/Auth_cubit/home_page_cubit.dart';

import '../../data/entity/users.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser;
  final TextEditingController _Postcontroller = TextEditingController();

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomePageCubit()..getPost()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(user!.email.toString()),
          actions: [
            IconButton(
              onPressed: signOut,
              icon: const Icon(
                Icons.logout_rounded,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<HomePageCubit, List<Users>>(
                builder: (context, users) {
                  print('bu user mesaji : $users');
                  if (users.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        var user = users[index];
                        return ListTile(
                          title: Text(user.name),
                          subtitle: Text(user.mesage),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _Postcontroller,
                      decoration: const InputDecoration(
                        hintText: 'Post it....',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      // Mesajı göndərmək üçün funksiyanı bura əlavə edin
                      String message = _Postcontroller.text;
                      if (message.isNotEmpty) {
                        context.read<HomePageCubit>().addPost(
                            user!.email.toString(), _Postcontroller.text);
                        _Postcontroller.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

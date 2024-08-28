import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/ui/cubit/Auth_cubit/home_page_cubit.dart';
import '../../../data/entity/users.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final user = FirebaseAuth.instance.currentUser;
  final TextEditingController _postController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
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
                  if (users.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        var userPost = users[index];
                        bool isLiked = userPost.likes.containsKey(FirebaseAuth.instance.currentUser!.uid);

                        return ListTile(
                          title: Text(userPost.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(userPost.mesage),
                              StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('Posts')
                                    .doc(userPost.id)
                                    .collection('Comments')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    var comments = snapshot.data!.docs;
                                    return Column(
                                      children: comments.map((commentDoc) {
                                        var commentData = commentDoc.data();
                                        return ListTile(
                                          title: Text(commentData['comment']),
                                          subtitle: Text(commentData['userId']),
                                        );
                                      }).toList(),
                                    );
                                  }
                                  return const Center(child: CircularProgressIndicator());
                                },
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      isLiked ? Icons.favorite : Icons.favorite_border,
                                      color: isLiked ? Colors.red : null,
                                    ),
                                    onPressed: () {
                                      context.read<HomePageCubit>().toggleLike(userPost.id, !isLiked);
                                    },
                                  ),
                                  Text('${userPost.likesCount} Likes'),
                                ],
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.comment),
                            onPressed: () {
                              _showCommentDialog(context, userPost.id);
                            },
                          ),
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
                      controller: _postController,
                      decoration: const InputDecoration(
                        hintText: 'Post it....',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      String message = _postController.text;
                      if (message.isNotEmpty) {
                        context.read<HomePageCubit>().addPost(
                            user!.email.toString(), _postController.text);
                        _postController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        drawer: Drawer(
          
          child:ListView(
            children: [
              DrawerHeader(child: Text(user!.email.toString())),
              ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.pushNamed(context, '/home');
              },
            ),

                 ListTile(
              title: const Text('Share Image'),
              onTap: () {
                Navigator.pushNamed(context, '/image_share');
              },
            ),

            ]

          
          ),
        ),
      ),
    );
  }

  void _showCommentDialog(BuildContext context, String postId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Comment'),
          content: TextField(
            controller: _commentController,
            decoration: const InputDecoration(hintText: 'Enter your comment'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                String comment = _commentController.text;
                if (comment.isNotEmpty) {
                  context.read<HomePageCubit>().addComment(postId, user!.email.toString(), comment);
                  _commentController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

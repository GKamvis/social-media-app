import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/data/entity/users.dart';
import '../../../data/repo/user_repo.dart';

class HomePageCubit extends Cubit<List<Users>> {
  HomePageCubit() : super([]);

  var collectionPosts = FirebaseFirestore.instance.collection('Posts');
  var repo = UserRepo();

  Future<void> getPost() async {
    collectionPosts.snapshots().listen((event) {
      var postList = <Users>[];

      var documents = event.docs;

      print('bu tam  documentlər : $documents');

      for (var document in documents) {
        var key = document.id;
        var data = document.data();
        print(' bu for içidə document data ${document.data()}');

        var user = Users.fromJson(data, key);

        postList.add(user);
      }
      print('bu postList mesaji : $postList');
      emit(postList);
    });
  }

  Future<void> addPost(String name, String mesage) async {
    await repo.addPost(name, mesage);
  }

  Future<void> addComment(String postId, String userId, String comment) async {
    await repo.addComment(postId, userId, comment);
  }


  Future<void> toggleLike(String postId, bool isLiked) async {
    await repo.toggleLike(postId, isLiked);
    getPost(); 
  }

  Future<List<Map<String, dynamic>>> getComments(String postId) async {
  QuerySnapshot commentsSnapshot = await FirebaseFirestore.instance
      .collection('Posts')
      .doc(postId)
      .collection('Comments')
      .orderBy('timestamp')
      .get();

  return commentsSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
}




}

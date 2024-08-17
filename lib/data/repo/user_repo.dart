import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepo {
  var collectionPosts = FirebaseFirestore.instance.collection('Posts');

  Future<void> addPost(String name, String mesage) async {
    var newMesage = HashMap<String, dynamic>();
    newMesage['name'] = name;
    newMesage['mesage'] = mesage;
    newMesage['likes'] = {};

    await collectionPosts.add(newMesage);
  }

  Future<void> addComment(String postId, String userId, String comment) async {
  DocumentReference postRef = FirebaseFirestore.instance.collection('Posts').doc(postId);

  await postRef.collection('Comments').add({
    'userId': userId,
    'comment': comment,
    'timestamp': FieldValue.serverTimestamp(),
  });
}



   Future<void> toggleLike(String postId, bool isLiked) async {
    var postRef = FirebaseFirestore.instance.collection('Posts').doc(postId);
    var currentUserId = FirebaseAuth.instance.currentUser!.uid;

    if (isLiked) {
      // Like əlavə et
      await postRef.update({
        'likes.$currentUserId': true,
        'likesCount': FieldValue.increment(1),
      });
    } else {
      // Like çıxar
      await postRef.update({
        'likes.$currentUserId': FieldValue.delete(),
        'likesCount': FieldValue.increment(-1),
      });
    }
  }
}

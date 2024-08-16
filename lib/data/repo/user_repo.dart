import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepo {
  var collectionPosts = FirebaseFirestore.instance.collection('Posts');

  Future<void> addPost(String name, String mesage) async {
    var newMesage = HashMap<String, dynamic>();
    newMesage['name'] = name;
    newMesage['mesage'] = mesage;

    await collectionPosts.add(newMesage);
  }
}

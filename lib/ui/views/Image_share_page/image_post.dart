import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:myapp/data/repo/user_repo.dart';
import 'package:myapp/ui/cubit/Auth_cubit/home_page_cubit.dart';

import '../../../data/entity/users.dart';

class ImageUploadService {
  final FirebaseStorage _storage =
      FirebaseStorage.instanceFor(bucket: "mini-social-c7847.appspot.com");

  Future<String?> uploadImage(XFile image) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = _storage.ref().child('images').child(fileName);

      UploadTask uploadTask = ref.putFile(File(image.path));
      TaskSnapshot snapshot = await uploadTask;

      String downloadUrl = await snapshot.ref.getDownloadURL();
      print("Şəkil URL: $downloadUrl"); // Səhv tapmaq üçün
      return downloadUrl;
    } catch (e) {
      print("Şəkil yükləməkdə səhv: $e"); // Səhvləri göstərmək üçün
      return null;
    }
  }

  Future<int> getFileCount() async {
    try {
      ListResult result = await _storage.ref('images/').listAll();
      return result.items.length;
    } catch (e) {
      print("Fayl sayını əldə etməkdə səhv: $e");
      return 0;
    }
  }
}

class ImagePost extends StatefulWidget {
  const ImagePost({super.key});

  @override
  _ImagePostState createState() => _ImagePostState();
}

class _ImagePostState extends State<ImagePost> {
  final ImagePicker _picker = ImagePicker();
  final UserRepo repo = UserRepo();
  final List<XFile> _images = [];
  int _fileCount = 0;

  @override
  void initState() {
    super.initState();
    _loadFileCount();
  }

  Future<void> _loadFileCount() async {
    int count = await ImageUploadService().getFileCount();
    setState(() {
      _fileCount = count;
    });
  }

  Future<void> _pickImageAndUpload() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final String? imageUrl =
          await ImageUploadService().uploadImage(pickedFile);
      if (imageUrl != null) {
        // Şəkil URL-ni Firestore-a əlavə edin
        await repo.addPost("User Name", "Sample message", imageUrl);
        setState(() {
          _images.add(pickedFile);
          _fileCount += 1; // Fayl sayını artırın
        });
      } else {
        print("Şəkil URL-i əldə edilə bilmədi.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double imageHeight = MediaQuery.of(context).size.height * 0.3;
    final double imageWidth = MediaQuery.of(context).size.width * 0.8;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomePageCubit()..getPost()),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Image Post'),
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<HomePageCubit, List<Users>>(
                  builder: (context, posts) {
                return ListView.builder(
                  itemCount: _fileCount, // Fayl sayını burada istifadə edirik
                  itemBuilder: (context, index) {
                    final post = posts.isNotEmpty && index < posts.length
                        ? posts[index]
                        : null;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            height: imageHeight,
                            width: imageWidth,
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: post?.imageUrl != null
                                ? Image.network(post!.imageUrl!,
                                    fit: BoxFit.cover)
                                : const Center(child: Text("Şəkil yoxdur")),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(CupertinoIcons.heart),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(CupertinoIcons.chat_bubble),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _images.removeAt(index);
                                      _fileCount -= 1; // Fayl sayını azaldın
                                    });
                                  },
                                  icon: const Icon(CupertinoIcons.delete),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _pickImageAndUpload,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

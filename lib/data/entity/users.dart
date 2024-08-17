class Users {
  String name;
  String id;
  String mesage;
  Map<String, bool> likes;
  int likesCount ;
  List<Map<String, dynamic>> comments; 


  Users({
    required this.name,
    required this.id,
    required this.mesage,
    required this.likes ,
    required this.likesCount,
    required this.comments,
  });

  factory Users.fromJson(Map<dynamic, dynamic> json, String key) {
    return Users(
        name: json['name'] as String,
        id: key,
        mesage: json['mesage'] as String , 
        likes: Map<String, bool>.from(json['likes'] ?? {} ), 
        likesCount:json['likesCount'] as int? ?? 0, 
        comments: List<Map<String, dynamic>>.from(json['comments'] ?? []),
        

);


  }
}

class Users {
  String name;
  String id;
  String mesage;


  Users({
    required this.name,
    required this.id,
    required this.mesage,
  });


  factory Users.fromJson(Map<dynamic , dynamic> json , String key) {
    return Users(name : json['name']  as String, id :key , mesage : json['mesage'] as String);
  }
}

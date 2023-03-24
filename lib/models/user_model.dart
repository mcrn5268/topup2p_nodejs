class UserModel {
  String? uid;
  final String email;
  String name;
  final String type;
  String image;
  String image_url;

  UserModel({
    this.uid,
    required this.email,
    required this.name,
    required this.type,
    required this.image,
    required this.image_url,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'name': name,
        'type': type,
        'image': image,
        'image_url': image_url,
      };

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'email': email,
        'name': name,
        'type': type,
        'image': image,
        'image_url': image_url,
      };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        uid: map['uid'] as String,
        email: map['email'] as String,
        name: map['name'] as String,
        type: map['type'] as String,
        image: map['image'] as String,
        image_url: map['image_url'] as String,
      );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json['_id'] as String?,
        email: json['email'] as String,
        name: json['name'] as String,
        type: json['type'] as String,
        image: json['image'] as String,
        image_url: json['image_url'] as String,
      );
}

class UserModel {
  final String name;
  final String uid;
  final String profilePic;
  final bool isOnline;
  final String email;
  final List<String> groupID;

  UserModel({
    required this.name,
    required this.uid,
    required this.profilePic,
    required this.isOnline,
    required this.email,
    required this.groupID,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uid': uid,
      'profilePic': profilePic,
      'isOnline': isOnline,
      'email': email,
      'groupId': groupID,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      uid: map['uid'] ?? '',
      profilePic: map['profilePic'] ?? '',
      isOnline: map['isOnline'] ?? false,
      email: map['email'] ?? '',
      groupID: List<String>.from(map['groupId']),
    );
  }
}

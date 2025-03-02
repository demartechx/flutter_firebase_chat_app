class ChatUser {
  bool isOnline;
  String? pushToken;
  String? createdAt;
  String id;
  String image;
  String email;
  String about;
  String? lastActive;
  String name;

  ChatUser({
    required this.isOnline,
    required this.id,
    this.pushToken,
    this.createdAt,
    required this.image,
    required this.email,
    required this.about,
    this.lastActive,
    required this.name,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      isOnline: json['is_online'] ?? false,
      pushToken: json['push_token'] ?? '',
      id: json['id'] ?? '',
      createdAt: json['created_at'] ?? '',
      image: json['image'] ?? '',
      email: json['email'] ?? '',
      about: json['about'] ?? '',
      lastActive: json['last_active'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_online': isOnline,
      'push_token': pushToken,
      'created_at': createdAt,
      'image': image,
      'id': id,
      'email': email,
      'about': about,
      'last_active': lastActive,
      'name': name,
    };
  }
}

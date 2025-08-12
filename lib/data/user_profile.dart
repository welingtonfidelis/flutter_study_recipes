class UserProfile {
  final String id;
  final String email;
  final String username;
  final String avatarUrl;

  UserProfile({
    required this.id,
    required this.email,
    required this.username,
    required this.avatarUrl,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      avatarUrl: json['avatarUrl'] as String,
    );
  }

  factory UserProfile.fromSupabase(
    Map<String, dynamic> userData,
    Map<String, dynamic> profileData,
  ) {
    return UserProfile(
      id: userData['id'] ?? '',
      email: userData['email'] ?? '',
      username: profileData['username'] ?? '',
      avatarUrl: profileData['avatarUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'avatarUrl': avatarUrl,
    };
  }

  @override
  String toString() {
    return 'UserProfile(username: $username)';
  }
}

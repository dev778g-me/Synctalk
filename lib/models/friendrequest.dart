class FriendRequestUser {
  final String uid;
  final String name;
  final String about;
  final String imageUrl;

  FriendRequestUser({
    required this.uid,
    required this.name,
    required this.about,
    required this.imageUrl,
  });

  // Factory constructor to initialize from Firestore document
  factory FriendRequestUser.fromFirestore(
      String uid, Map<String, dynamic> data) {
    return FriendRequestUser(
      uid: uid,
      name: data['name'] ?? 'No name',
      about: data['about'] ?? 'No description',
      imageUrl: data['imageurl'] ?? '',
    );
  }
}

class Post {
  String id;
  String profileImageUrl;
  String comment;
  String foodPictureUrl;
  String timestamp;

  Post({
    required this.id,
    required this.profileImageUrl,
    required this.comment,
    required this.foodPictureUrl,
    required this.timestamp,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as String,
      profileImageUrl: json['profileImageUrl'] as String,
      comment: json['comment'] as String,
      foodPictureUrl: json['foodPictureUrl'] as String,
      timestamp: json['timestamp'] as String,
    );
  }
}

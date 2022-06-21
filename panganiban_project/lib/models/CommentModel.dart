class Comment {
  final String id;
  final String text;
  final String postId;
  final String username;
  final String date;

  Comment({
    required this.id,
    required this.text,
    required this.postId,
    required this.username,
    required this.date
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      text: json['text'],
      postId: json['postId'],
      username: json['username'],
      date: json['date']
    );
  }
}
class Post {
  final String id;
  final String text;
  final String username;
  final bool public;
  final int date;
  final int updated;

  const Post({
    required this.id,
    required this.text,
    required this.username,
    required this.public,
    required this.date,
    required this.updated,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      text: json['text'],
      username: json['username'],
      public: json['public'],
      date: json['date'],
      updated: json['updated']
    );
  }

}
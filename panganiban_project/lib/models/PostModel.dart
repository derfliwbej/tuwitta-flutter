class Post {
  final String id;
  final String text;
  final String author;
  final bool public;
  final int date;
  final int updated;

  const Post({
    required this.id,
    required this.text,
    required this.author,
    required this.public,
    required this.date,
    required this.updated,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      text: json['text'],
      author: json['author'],
      public: json['public'],
      date: json['date'],
      updated: json['updated']
    );
  }

}
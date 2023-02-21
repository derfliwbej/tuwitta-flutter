class User {
  final String username;
  final String firstName;
  final String lastName;

  User({
    required this.username,
    required this.firstName,
    required this.lastName
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        username: json['username'],
        firstName: json['firstName'],
        lastName: json['lastName'],
    );
  }
}
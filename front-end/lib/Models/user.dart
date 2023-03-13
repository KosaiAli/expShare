class User {
  String id;
  String email;
  String name;
  User({required this.id, required this.email, required this.name});

  static User userfromJson(Map json) {
    return User(
        id: json['id'].toString(), email: json['email'], name: json['name']);
  }
}

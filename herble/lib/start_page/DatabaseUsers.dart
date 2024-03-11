class User {
  final String email;
  final String username;
  final int waterTimeMin;

  User(
      {required this.email,
      required this.username,
      required this.waterTimeMin});

  Map<String, dynamic> toJson() => {
        "email": email,
        "username": username,
        "waterTimeMin": waterTimeMin,
      };

  static User fromJson(Map<String, dynamic> json) => User(
      email: json["email"],
      username: json['username'],
      waterTimeMin: json['wateringTime']);
}

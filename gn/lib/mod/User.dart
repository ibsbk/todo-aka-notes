class User {
  int? id;
  String? name;
  String? google_id;

  User({this.name, this.google_id, this.id});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      name: json["name"],
      google_id: json["google_id"],
    );
  }

}

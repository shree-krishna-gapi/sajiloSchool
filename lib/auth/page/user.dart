class User {
  int id;
  String name;
  int email;
  String imageLocation;
  String emailAddress;
  User({this.id, this.name, this.email,this.imageLocation,this.emailAddress});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["ProfileId"] as int,
      name: json["StudentName"] as String,
      email: json["RollNo"] as int,
      imageLocation: json["ImageLocation"] as String,
      emailAddress: json["EmailAddress"] as String,
    );
  }
}
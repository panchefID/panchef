class RegisterModel {
  String email;
  String firstName;
  String lastName;
  String photoUrl;

  RegisterModel({this.email = "", this.firstName = "", this.lastName = "", this.photoUrl = ""});

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'photoUrl': photoUrl
    };
  }

  RegisterModel.fromMap(Map<String, dynamic> registerMap)
      : email = registerMap["email"],
        firstName = registerMap["firstName"],
        lastName = registerMap["lastName"],
        photoUrl = registerMap["photoUrl"];
}

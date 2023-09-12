class UserModel {
  String? dateOfBirth;
  String? firstName;
  String? lastName;
  String? gender;
  String? email;
  String? password;
  UserModel();
  UserModel.fromJson(Map<String, dynamic> json){
    dateOfBirth: json["Date of Birth"];
    firstName: json["First name"];
    lastName: json["Last name"];
    gender: json["Gender"];
    email: json["Email"];
    password: json["Password"];
  }

  Map<String, dynamic> toJson() => {
    "Date of Birth": dateOfBirth,
    "First name": firstName,
    "Last name": lastName,
    "Gender": gender,
    "Email": email,
    "Password": password,
  };
}

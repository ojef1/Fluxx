
class UserModel {
  String? name;
  double? salary;
  String? picture;

  UserModel({
    this.name,
    this.salary,
    this.picture,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'salary': salary,
      'picture': picture,
    };
  }
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      salary: json['salary'],
      picture: json['picture'],
    );
  }
}
class Profile {
  Profile({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.avatarSource,
    this.dateOfBirth,
    this.gender,
    this.status,
    this.deviceToken,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String name;
  String email;
  String phoneNumber;
  String avatarSource;
  DateTime dateOfBirth;
  int gender;
  int status;
  String deviceToken;
  DateTime createdAt;
  DateTime updatedAt;

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      phoneNumber: json["phone_number"],
      avatarSource: json["avatar_source"],
      dateOfBirth: DateTime.parse(json["date_of_birth"]),
      gender: json["gender"],
      status: json["status"],
      deviceToken: json["device_token"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone_number": phoneNumber,
        "avatar_source": avatarSource,
        "date_of_birth":
            "${dateOfBirth.year.toString().padLeft(4, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}",
        "gender": gender,
        "status": status,
        "device_token": deviceToken,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

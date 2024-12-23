class UserSocialLoginDetailModal {
  int idType;
  String emailId;
  String googleId;
  UserSocialLoginDetailModal({
    required this.idType,
    required this.emailId,
    required this.googleId,
  });

  toJson() {
    Map<String, dynamic> data = {};
    data["idType"] = idType;
    data["emailId"] = emailId;
    data["googleId"] = googleId;
    return data;
  }
}
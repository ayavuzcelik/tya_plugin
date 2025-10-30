class TuyaUserModel {
  /// User Id
  int uId;

  /// User Session Id
  int uSId;

  /// User Type
  int uType;

  TuyaUserModel({required this.uId, required this.uSId, required this.uType});

  factory TuyaUserModel.fromJson(Map<String, dynamic> json) {
    return TuyaUserModel(
      uId: json['uId'],
      uSId: json['uSId'],
      uType: json['uType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'uId': uId, 'uSId': uSId, 'uType': uType};
  }
}

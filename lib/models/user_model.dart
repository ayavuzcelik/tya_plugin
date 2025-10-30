class ThingSmartUserModel {
  /// User Id
  int uId;

  /// User Session Id
  int uSId;

  /// User Type
  int uType;

  ThingSmartUserModel({
    required this.uId,
    required this.uSId,
    required this.uType,
  });

  factory ThingSmartUserModel.fromJson(Map<String, dynamic> json) {
    return ThingSmartUserModel(
      uId: json['uId'],
      uSId: json['uSId'],
      uType: json['uType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'uId': uId, 'uSId': uSId, 'uType': uType};
  }
}

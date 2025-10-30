class ThingSmartDeviceModel {
  final String devId;

  final String macId;

  final bool isOnline;

  final String category;

  ThingSmartDeviceModel.fromJson(Map<String, dynamic> json)
    : devId = json['devId'],
      macId = json['mac'],
      isOnline = json['isOnline'],
      category = json['category'];

  Map<String, dynamic> toJson() => {
    "devId": devId,
    "mac": macId,
    "isOnline": isOnline,
    "category": category,
  };
}

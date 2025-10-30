class TuyaHomeModel {
  int homeId;

  TuyaHomeModel({required this.homeId});

  factory TuyaHomeModel.fromJson(Map<String, dynamic> json) {
    return TuyaHomeModel(homeId: json['homeId']);
  }

  Map<String, dynamic> toJson() {
    return {'homeId': homeId};
  }
}

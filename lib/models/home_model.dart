class ThingSmartHomeModel {
  int homeId;

  ThingSmartHomeModel({required this.homeId});

  factory ThingSmartHomeModel.fromJson(Map<String, dynamic> json) {
    return ThingSmartHomeModel(homeId: json['homeId']);
  }

  Map<String, dynamic> toJson() {
    return {'homeId': homeId};
  }
}

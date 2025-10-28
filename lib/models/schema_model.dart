import 'dart:convert';

List<ThingSmartSchemaModel> thingSmartSchemaModelFromJson(String str) =>
    List<ThingSmartSchemaModel>.from(
        json.decode(str).map((x) => ThingSmartSchemaModel.fromJson(x)));

class ThingSmartSchemaModel {
  /// The code of the schema model.
  final String code;

  /// The id of the schema model.
  final int id;

  /// The mode of the schema model.
  final Mode mode;

  /// The name of the schema model.
  final String name;

  /// The property of the schema model, if any.
  final Property? property;

  /// The type of the schema model.
  final ThingSmartSchemaModelType type;

  ThingSmartSchemaModel({
    required this.code,
    required this.id,
    required this.mode,
    required this.name,
    this.property,
    required this.type,
  });

  factory ThingSmartSchemaModel.fromJson(Map<String, dynamic> json) =>
      ThingSmartSchemaModel(
        code: json["code"],
        id: json["id"],
        mode: modeValues.map[json["mode"]]!,
        name: json["name"],
        property: json["property"] == null
            ? null
            : Property.fromJson(json["property"]),
        type: thingSmartSchemaModelTypeValues.map[json["type"]]!,
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "id": id,
        "mode": modeValues.reverse[mode],
        "name": name,
        "property": property?.toJson(),
        "type": thingSmartSchemaModelTypeValues.reverse[type],
      };
}

/// Reads and writes attributes of the DP. rw: send and report | ro: only report | wr: only send.

enum Mode { ro, rw, wr }

final modeValues = EnumValues({
  "ro": Mode.ro,
  "rw": Mode.rw,
  "wr": Mode.wr,
});

class Property {
  final List<String>? range;
  final PropertyType type;
  final List<String>? label;
  final int? selectedValue;
  final String? unit;
  final num? min;
  final num? max;
  final int? scale;
  final int? maxlen;
  final num? step;

  Property({
    this.range,
    required this.type,
    this.label,
    this.selectedValue,
    this.unit,
    this.min,
    this.max,
    this.scale,
    this.maxlen,
    this.step,
  });

  factory Property.fromJson(Map<String, dynamic> json) => Property(
        range: json["range"] == null
            ? []
            : List<String>.from(json["range"]!.map((x) => x)),
        type: propertyTypeValues.map[json["type"]]!,
        label: json["label"] == null
            ? []
            : List<String>.from(json["label"]!.map((x) => x)),
        selectedValue: json["selectedValue"],
        unit: json["unit"],
        min: json["min"]?.toDouble(),
        max: json["max"]?.toDouble(),
        scale: json["scale"],
        maxlen: json["maxlen"] is String
            ? int.tryParse(json["maxlen"]) ?? null
            : json["maxlen"],
        step: json["step"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "range": range == null ? [] : List<dynamic>.from(range!.map((x) => x)),
        "type": propertyTypeValues.reverse[type],
        "label": label == null ? [] : List<dynamic>.from(label!.map((x) => x)),
        "selectedValue": selectedValue,
        "unit": unit,
        "min": min,
        "max": max,
        "scale": scale,
        "maxlen": maxlen,
        "step": step,
      };
}

///The type of object. enum: enumerated | bool: Boolean | string: character | value: numeric | bitmap: fault.

enum PropertyType { _bool, _enum, _string, _value, _bitmap, _raw }

final propertyTypeValues = EnumValues({
  "bool": PropertyType._bool,
  "enum": PropertyType._enum,
  "value": PropertyType._value,
  "string": PropertyType._string,
  "bitmap": PropertyType._bitmap,
  "raw": PropertyType._raw,
});

///The type of DP. obj: numeric, character, Boolean, enumeration, and fault | raw: the pass-through type.
enum ThingSmartSchemaModelType { obj, raw }

final thingSmartSchemaModelTypeValues = EnumValues({
  "obj": ThingSmartSchemaModelType.obj,
  "raw": ThingSmartSchemaModelType.raw,
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
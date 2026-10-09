class LocationDto {
  final String id;
  final String code;
  final String name;
  final String address;
  final String city;
  final String province;
  final bool isHq;

  const LocationDto({
    required this.id,
    required this.code,
    required this.name,
    required this.address,
    required this.city,
    required this.province,
    required this.isHq,
  });

  factory LocationDto.fromJson(Map<String, dynamic> json) {
    return LocationDto(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
      province: json['province'] as String,
      isHq: json['isHq'] as bool,
    );
  }
}

class LocationSummaryDto {
  final String id;
  final String code;
  final String name;

  const LocationSummaryDto({
    required this.id,
    required this.code,
    required this.name,
  });

  factory LocationSummaryDto.fromJson(Map<String, dynamic> json) {
    return LocationSummaryDto(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
    );
  }
}

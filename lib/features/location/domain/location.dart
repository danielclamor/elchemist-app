import 'package:elchemist_app/features/location/data/location_dto.dart';

class Location {
  final String id;
  final String code;
  final String name;
  final String address;
  final String city;
  final String province;
  final bool isHq;

  const Location({
    required this.id,
    required this.code,
    required this.name,
    required this.address,
    required this.city,
    required this.province,
    required this.isHq,
  });

  factory Location.fromDto(LocationDto l) {
    return Location(
      id: l.id,
      code: l.code,
      name: l.name,
      address: l.address,
      city: l.city,
      province: l.province,
      isHq: l.isHq,
    );
  }
}

class LocationSummary {
  final String id;
  final String code;
  final String name;
  final bool isHq;

  const LocationSummary({
    required this.id,
    required this.code,
    required this.name,
    required this.isHq,
  });

  factory LocationSummary.fromDto(LocationSummaryDto l) {
    return LocationSummary(
      id: l.id,
      code: l.code,
      name: l.name,
      isHq: l.isHq,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LocationSummary &&
        other.runtimeType == runtimeType &&
        other.id == id &&
        other.code == code;
  }

  @override
  int get hashCode => Object.hash(id, code);
}

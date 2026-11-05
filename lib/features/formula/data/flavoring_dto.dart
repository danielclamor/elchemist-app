import 'package:elchemist_app/features/flavoring_option.dart/data/flavoring_option.dart';

class FlavoringDto {
  final FlavoringOptionDto flavoringOption;
  final double ratio;

  const FlavoringDto({
    required this.flavoringOption,
    required this.ratio,
  });

  factory FlavoringDto.fromJson(Map<String, dynamic> json) {
    return FlavoringDto(
      flavoringOption: FlavoringOptionDto.fromJson(
          json['flavoringOption'] as Map<String, dynamic>),
      ratio: _toDouble(json['ratio']),
    );
  }

  static double _toDouble(Object? v) => (v as num).toDouble();
}

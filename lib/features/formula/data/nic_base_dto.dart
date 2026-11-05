import 'package:elchemist_app/features/nic_base_option/data/nic_base_option_dto.dart';

class NicBaseDto {
  final double ratio;
  final NicBaseOptionDto nicBaseOption;

  const NicBaseDto({
    required this.ratio,
    required this.nicBaseOption,
  });

  factory NicBaseDto.fromJson(Map<String, dynamic> json) {
    return NicBaseDto(
      nicBaseOption: NicBaseOptionDto.fromJson(
          json['nicBaseOption'] as Map<String, dynamic>),
      ratio: _toDouble(json['ratio']),
    );
  }

  static double _toDouble(Object? v) => (v as num).toDouble();
}
